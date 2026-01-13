<?php
session_start();
require_once "../../models/XmlManager.php";

// Vérifier connexion et rôle
if (!isset($_SESSION["user"]) || $_SESSION["user"]["role"] !== "student") {
    header("Location: ../../login.php");
    exit;
}

// XML
$studentsXml = new XmlManager(__DIR__ . "/../../data/students.xml");
$absencesXml = new XmlManager(__DIR__ . "/../../data/absences.xml");

// Récupérer l'étudiant connecté
$studentEmail = $_SESSION["user"]["email"];
$studentData = null;

foreach ($studentsXml->getAll()->student as $s) {
    if ((string)$s->email === $studentEmail) {
        $studentData = $s;
        break;
    }
}

if (!$studentData) {
    echo "Étudiant non trouvé";
    exit;
}

// Récupérer ses absences
$studentId = (string)$studentData['id'];
$absences = [];
foreach ($absencesXml->getAll()->absence as $a) {
    if ((string)$a['student_id'] === $studentId) {
        $absences[] = $a;
    }
}

// Vérifier pénalité (exemple : plus de 10 absences)
$penalty = count($absences) >= 10;
?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Étudiant</title>
    <link rel="stylesheet" href="../../assets/css/style.css">
</head>
<body>

<div class="container">
    <h1>🎓 Dashboard Étudiant</h1>

    <div class="actions">
        <span>Bienvenue, <?= htmlspecialchars($studentData->name) ?></span>
        <a href="../../logout.php" class="btn logout">🔒 Déconnexion</a>
    </div>

    <h2>Informations personnelles</h2>
    <p><strong>Nom :</strong> <?= htmlspecialchars($studentData->name) ?></p>
    <p><strong>Email :</strong> <?= htmlspecialchars($studentData->email) ?></p>
    <p><strong>Classe :</strong> <?= htmlspecialchars($studentData->class) ?></p>

    <?php if($penalty): ?>
        <p style="color:red; font-weight:bold;">⚠️ Attention : Vous avez atteint le nombre maximum d’absences !</p>
    <?php endif; ?>

    <h2>Mes absences</h2>
    <table>
        <tr>
            <th>Date</th>
            <th>Module</th>
        </tr>
        <?php if($absences): ?>
            <?php foreach($absences as $a): ?>
                <tr>
                    <td><?= htmlspecialchars($a->date) ?></td>
                    <td><?= htmlspecialchars($a->module) ?></td>
                </tr>
            <?php endforeach; ?>
        <?php else: ?>
            <tr><td colspan="2" style="text-align:center;">Aucune absence enregistrée</td></tr>
        <?php endif; ?>
    </table>
</div>

</body>
</html>
