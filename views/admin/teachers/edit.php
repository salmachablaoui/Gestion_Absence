<?php
session_start();
require_once "../../../models/XmlManager.php";

if (!isset($_SESSION["user"]) || $_SESSION["user"]["role"] !== "admin") {
    header("Location: ../../../login.php");
    exit;
}

if (!isset($_GET['id'])) {
    header("Location: ../dashboard.php");
    exit;
}

$id = $_GET['id'];

$teachersXml = new XmlManager(__DIR__ . "/../../../data/teachers.xml");
$usersXml = new XmlManager(__DIR__ . "/../../../data/users.xml");

$teacher = null;
foreach ($teachersXml->getAll()->teacher as $t) {
    if ((string)$t['id'] === $id) {
        $teacher = $t;
        break;
    }
}

if (!$teacher) {
    header("Location: ../dashboard.php");
    exit;
}

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $name = $_POST['name'];
    $email = $_POST['email'];
    $module = $_POST['module'];

    // Update teachers.xml
    $teacher->name = $name;
    $teacher->email = $email;
    $teacher->module = $module;
    $teachersXml->save();

    // Update users.xml
    foreach ($usersXml->getAll()->user as $user) {
        if ((string)$user['id'] === $id) {
            $user->name = $name;
            $user->email = $email;
            $usersXml->save();
            break;
        }
    }

    header("Location: ../dashboard.php");
    exit;
}
?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Modifier Enseignant</title>
    <link rel="stylesheet" href="../../../assets/css/style.css">
</head>
<body>

<div class="modal" id="editModal">
    <div class="modal-content">
        <a href="../dashboard.php" class="close" id="closeModal">&times;</a>
        <h2>✏ Modifier Enseignant</h2>
        <form method="post">
            Nom:<br>
            <input type="text" name="name" value="<?= htmlspecialchars($teacher->name) ?>" required>

            Email:<br>
            <input type="email" name="email" value="<?= htmlspecialchars($teacher->email) ?>" required>

            Module:<br>
            <input type="text" name="module" value="<?= htmlspecialchars($teacher->module) ?>" required>

            <div class="form-buttons">
                <button type="submit" class="btn">Enregistrer</button>
                <a href="../dashboard.php" class="btn logout">Annuler</a>
            </div>
        </form>
    </div>
</div>

<script>
    // Affiche le modal
    document.getElementById("editModal").style.display = "block";

    // Fermer avec la croix
    document.getElementById("closeModal").onclick = function() {
        window.location.href = "../dashboard.php";
    }

    // Fermer en cliquant en dehors
    window.onclick = function(event) {
        let modal = document.getElementById("editModal");
        if (event.target === modal) {
            window.location.href = "../dashboard.php";
        }
    }
</script>

</body>
</html>
