<?php
session_start();
require_once "../../models/XmlManager.php";

// Vérifier que l'utilisateur est enseignant
if (!isset($_SESSION["user"]) || $_SESSION["user"]["role"] !== "teacher") {
    header("Location: ../../login.php");
    exit;
}

// XML
$teachersXml = new XmlManager(__DIR__ . "/../../data/teachers.xml");
$studentsXml = new XmlManager(__DIR__ . "/../../data/students.xml");
$absencesXml = new XmlManager(__DIR__ . "/../../data/absences.xml");

// Enseignant connecté
$teacherEmail = $_SESSION["user"]["email"];
$teacherData = null;

foreach ($teachersXml->getAll()->teacher as $t) {
    if ((string)$t->email === $teacherEmail) {
        $teacherData = $t;
        break;
    }
}

if (!$teacherData) {
    die("Enseignant non trouvé");
}

// Classe et module de l'enseignant
$teacherClass = (string)$teacherData->class ?? "";
$teacherModule = (string)$teacherData->module ?? "";

// Étudiants de la classe
$students = [];
foreach ($studentsXml->getAll()->student as $s) {
    if ((string)$s->class === $teacherClass) {
        $students[] = $s;
    }
}

// Absences du jour
$today = date("Y-m-d");
$absences = [];
foreach ($absencesXml->getAll()->absence as $a) {
    if ((string)$a->date === $today) {
        $absences[(string)$a->studentId] = $a;
    }
}
?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Enseignant</title>
    <link rel="stylesheet" href="../../assets/css/style.css">
    <style>
        .btn { padding: 5px 10px; text-decoration: none; border: 1px solid #333; border-radius: 4px; }
        .btn.disabled { opacity: 0.5; pointer-events: none; }
        table { border-collapse: collapse; width: 100%; margin-top: 20px; }
        th, td { border: 1px solid #ccc; padding: 8px; text-align: center; }
    </style>
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
            <th>Actions</th>
        </tr>

        <?php if ($students): ?>
            <?php foreach ($students as $student): ?>
                <?php
                $studentId = (string)$student['id'];
                $absent = isset($absences[$studentId]);
                $absenceId = $absent ? (string)$absences[$studentId]['id'] : null;
                ?>
                <tr>
                    <td><?= htmlspecialchars($studentId) ?></td>
                    <td><?= htmlspecialchars($student->name) ?></td>
                    <td><?= htmlspecialchars($student->email) ?></td>
                    <td>
                        <a href="add_presence.php?id=<?= $studentId ?>&class=<?= urlencode($teacherClass) ?>"
                           class="btn <?= $absent ? 'disabled' : '' ?>" <?= $absent ? 'onclick="return false;"' : '' ?>>✔ Présent</a>
                    </td>
                    <td>
                        <a href="add_absence.php?id=<?= $studentId ?>&module=<?= urlencode($teacherModule) ?>"
                           class="btn <?= $absent ? 'disabled' : '' ?>" <?= $absent ? 'onclick="return false;"' : '' ?>>❌ Absence</a>
                    </td>
                    <td>
                        <?php if ($absent): ?>
                            <a href="edit_absence.php?id=<?= $absenceId ?>" class="btn">✏️ Modifier</a>
                            <a href="delete_absence.php?id=<?= $absenceId ?>" class="btn" onclick="return confirm('Supprimer cette absence ?')">🗑️ Supprimer</a>
                        <?php else: ?>
                            -
                        <?php endif; ?>
                    </td>
                </tr>
            <?php endforeach; ?>
        <?php else: ?>
            <tr><td colspan="6" style="text-align:center;">Aucun étudiant dans votre classe</td></tr>
        <?php endif; ?>
    </table>
</div>

</body>
</html>
