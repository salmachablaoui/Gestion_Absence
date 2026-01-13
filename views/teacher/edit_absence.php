<?php
session_start();
require_once "../../models/XmlManager.php";

// Vérifier que l'utilisateur est enseignant
if (!isset($_SESSION["user"]) || $_SESSION["user"]["role"] !== "teacher") {
    header("Location: ../../login.php");
    exit;
}

// XML
$absencesXml = new XmlManager(__DIR__ . "/../../data/absences.xml");
$studentsXml = new XmlManager(__DIR__ . "/../../data/students.xml");

// Récupérer l'ID de l'absence
if (!isset($_GET['id'])) {
    die("Absence ID manquant");
}

$absenceId = $_GET['id'];
$absenceData = null;

// Trouver l'absence
foreach ($absencesXml->getAll()->absence as $a) {
    if ((string)$a['id'] === $absenceId) {
        $absenceData = $a;
        break;
    }
}

if (!$absenceData) {
    die("Absence introuvable");
}

// Récupérer les informations de l'étudiant
$studentId = (string)$absenceData->studentId;
$studentName = "";
foreach ($studentsXml->getAll()->student as $s) {
    if ((string)$s['id'] === $studentId) {
        $studentName = (string)$s->name;
        break;
    }
}

// Traitement du formulaire
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $absenceData->studentId = $_POST['studentId'];
    $absenceData->module    = $_POST['module'];
    $absenceData->date      = $_POST['date'];
    $absenceData->status    = $_POST['status'];
    $absenceData->hours     = $_POST['hours'];

    $absencesXml->save();
    header("Location: dashboard.php");
    exit;
}
?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Modifier Absence</title>
    <link rel="stylesheet" href="../../assets/css/style.css">
</head>
<body>
<div class="container">
    <h1>✏️ Modifier Absence</h1>

    <form method="post" action="">
        <label>Étudiant :</label>
        <input type="text" name="studentName" value="<?= htmlspecialchars($studentName) ?>" disabled>
        <input type="hidden" name="studentId" value="<?= htmlspecialchars($studentId) ?>">

        <label>Module :</label>
        <input type="text" name="module" value="<?= htmlspecialchars($absenceData->module) ?>" required>

        <label>Date :</label>
        <input type="date" name="date" value="<?= htmlspecialchars($absenceData->date) ?>" required>

        <label>Status :</label>
        <select name="status" required>
            <option value="Absent" <?= $absenceData->status == 'Absent' ? 'selected' : '' ?>>Absent</option>
            <option value="Présent" <?= $absenceData->status == 'Présent' ? 'selected' : '' ?>>Présent</option>
        </select>

        <label>Heures :</label>
        <input type="number" name="hours" value="<?= htmlspecialchars($absenceData->hours) ?>" required min="1">

        <div class="form-buttons">
            <button type="submit" class="btn">Enregistrer</button>
            <a href="dashboard.php" class="btn logout">Annuler</a>
        </div>
    </form>
</div>
</body>
</html>
