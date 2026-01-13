<?php
session_start();
require_once "../../../models/XmlManager.php";

if (!isset($_SESSION["user"]) || $_SESSION["user"]["role"] !== "admin") {
    header("Location: ../../../login.php");
    exit;
}

// Init XML
$teachersXml = new XmlManager(__DIR__ . "/../../../data/teachers.xml");
$usersXml = new XmlManager(__DIR__ . "/../../../data/users.xml");

$teachers = $teachersXml->getAll()->teacher;
?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Liste Enseignants</title>
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
    <h1>👨‍🏫 Liste des enseignants</h1>
    <a href="../dashboard.php" class="btn">⬅ Retour Dashboard</a>

    <table>
        <tr>
            <th>ID</th>
            <th>Nom</th>
            <th>Email</th>
            <th>Module</th>
            <th>Actions</th>
        </tr>
        <?php if($teachers): ?>
            <?php foreach($teachers as $teacher): ?>
                <tr>
                    <td><?= htmlspecialchars($teacher['id']) ?></td>
                    <td><?= htmlspecialchars($teacher->name) ?></td>
                    <td><?= htmlspecialchars($teacher->email) ?></td>
                    <td><?= htmlspecialchars($teacher->module) ?></td>
                    <td>
                        <a href="delete.php?id=<?= $teacher['id'] ?>" class="delete"
                           onclick="return confirm('Voulez-vous vraiment supprimer cet enseignant ?')">Supprimer</a>
                    </td>
                </tr>
            <?php endforeach; ?>
        <?php else: ?>
            <tr><td colspan="5">Aucun enseignant trouvé.</td></tr>
        <?php endif; ?>
    </table>
</div>

</body>
</html>
