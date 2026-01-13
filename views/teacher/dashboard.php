<?php

session_start();
require_once "../../models/XmlManager.php";

if (!isset($_SESSION["user"]) || $_SESSION["user"]["role"] !== "teacher") {
    header("Location: ../../login.php");
    exit;
}

// XML
$teachersXml = new XmlManager(__DIR__ . "/../../data/teachers.xml");
$studentsXml = new XmlManager(__DIR__ . "/../../data/students.xml");
$absencesXml = new XmlManager(__DIR__ . "/../../data/absences.xml");

$teacherEmail = $_SESSION["user"]["email"];

// Récupérer l'enseignant connecté
$teacherData = null;
foreach ($teachersXml->getAll()->teacher as $t) {
    if ((string)$t->email === $teacherEmail) {
        $teacherData = $t;
        break;
    }
}

if (!$teacherData) {
    echo "Enseignant non trouvé";
    exit;
}

// Classe et module
$teacherClass = (string)$teacherData->class ?? "";
$teacherModule = (string)$teacherData->module ?? "";

// Récupérer les étudiants de la classe de l’enseignant
$students = [];
foreach ($studentsXml->getAll()->student as $s) {
    if ((string)$s->class === $teacherClass) {
        $students[] = $s;
    }
}
?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Enseignant</title>
    <link rel="stylesheet" href="../../assets/css/style.css">
</head>
<body>

<div class="container">
    <h1>📚 Dashboard Enseignant</h1>

    <div class="actions">
        <span>Bienvenue, <?= htmlspecialchars($teacherData->name) ?></span>
        <a href="../../logout.php" class="btn logout">🔒 Déconnexion</a>
    </div>

    <h2>Classe : <?= htmlspecialchars($teacherClass) ?> | Module : <?= htmlspecialchars($teacherModule) ?></h2>

    <h3>Liste des étudiants</h3>
    <table>
        <tr>
            <th>ID</th>
            <th>Nom</th>
            <th>Email</th>
            <th>Présence</th>
            <th>Absence</th>
        </tr>
        <?php if ($students): ?>
            <?php foreach ($students as $student): ?>
                <?php
                // Vérifier si l’étudiant est déjà absent aujourd'hui
                $today = date("Y-m-d");
                $absent = false;
                foreach ($absencesXml->getAll()->absence as $a) {
                    if ((string)$a['student_id'] === (string)$student['id'] && (string)$a['date'] === $today) {
                        $absent = true;
                        break;
                    }
                }
                ?>
                <tr>
                    <td><?= htmlspecialchars($student['id']) ?></td>
                    <td><?= htmlspecialchars($student->name) ?></td>
                    <td><?= htmlspecialchars($student->email) ?></td>
                    <td>
                        <a href="mark_presence.php?id=<?= $student['id'] ?>&class=<?= urlencode($teacherClass) ?>" class="btn">✔ Présent</a>
                    </td>
                    <td>
                        <a href="mark_absence.php?id=<?= $student['id'] ?>&class=<?= urlencode($teacherClass) ?>" class="btn <?= $absent ? 'disabled' : '' ?>"
                           <?= $absent ? 'onclick="return false;"' : '' ?>>❌ Absence</a>
                    </td>
                </tr>
            <?php endforeach; ?>
        <?php else: ?>
            <tr><td colspan="5" style="text-align:center;">Aucun étudiant dans votre classe</td></tr>
        <?php endif; ?>
    </table>
</div>

</body>
</html>
