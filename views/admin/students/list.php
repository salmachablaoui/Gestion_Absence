<?php
session_start();
require_once "../../../models/XmlManager.php";

// Sécurité : admin uniquement
if (!isset($_SESSION["user"]) || $_SESSION["user"]["role"] !== "admin") {
    header("Location: ../../../login.php");
    exit;
}

// Init XML
$studentsXml = new XmlManager(__DIR__ . "/../../../data/students.xml");
$usersXml    = new XmlManager(__DIR__ . "/../../../data/users.xml");

// 🗑 Suppression si id passé
if (isset($_GET['delete'])) {
    $idToDelete = $_GET['delete'];

    // Supprimer dans students.xml
    foreach ($studentsXml->getAll()->student as $key => $student) {
        if ((string)$student['id'] === $idToDelete) {
            unset($studentsXml->getAll()->student[$key]);
            $studentsXml->save();
            break;
        }
    }

    // Supprimer dans users.xml
    foreach ($usersXml->getAll()->user as $key => $user) {
        if ((string)$user['id'] === $idToDelete) {
            unset($usersXml->getAll()->user[$key]);
            $usersXml->save();
            break;
        }
    }

    header("Location: list.php");
    exit;
}

// Liste étudiants
$students = $studentsXml->getAll()->student;
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Liste Étudiants</title>
    <link rel="stylesheet" href="../../../assets/css/admin.css">
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background: #fff;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 0 10px rgba(0,0,0,.1);
        }
        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background: #3498db;
            color: #fff;
        }
        a.delete {
            color: #e74c3c;
            font-weight: bold;
            text-decoration: none;
        }
        a.delete:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="container">
    <h1>👨‍🎓 Liste des étudiants</h1>
    <a href="../dashboard.php" class="btn">⬅ Retour Dashboard</a>

    <table>
        <tr>
            <th>ID</th>
            <th>Nom</th>
            <th>Email</th>
            <th>Classe</th>
            <th>Actions</th>
        </tr>

        <?php if ($students): ?>
            <?php foreach ($students as $student): ?>
                <tr>
                    <td><?= htmlspecialchars($student['id']) ?></td>
                    <td><?= htmlspecialchars($student->name) ?></td>
                    <td><?= htmlspecialchars($student->email) ?></td>
                    <td><?= htmlspecialchars($student->class) ?></td>
                    <td>
                        <a href="delete.php?id=<?= $student['id'] ?>"
                           class="delete"
                           onclick="return confirm('Voulez-vous vraiment supprimer cet étudiant ?')">
                           Supprimer
                        </a>
                    </td>
                </tr>
            <?php endforeach; ?>
        <?php else: ?>
            <tr>
                <td colspan="5">Aucun étudiant trouvé.</td>
            </tr>
        <?php endif; ?>
    </table>
</div>

</body>
</html>