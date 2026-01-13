<?php
session_start();
require_once "../../../models/XmlManager.php";

if (!isset($_SESSION["user"]) || $_SESSION["user"]["role"] !== "admin") {
    header("Location: ../../../login.php");
    exit;
}

if (!isset($_GET['id'])) {
    header("Location: dashboard.php");
    exit;
}

$id = $_GET['id'];

$studentsXml = new XmlManager(__DIR__ . "/../../../data/students.xml");
$usersXml = new XmlManager(__DIR__ . "/../../../data/users.xml");

$student = null;
foreach ($studentsXml->getAll()->student as $s) {
    if ((string)$s['id'] === $id) {
        $student = $s;
        break;
    }
}

if (!$student) {
    header("Location: dashboard.php");
    exit;
}

$error = "";
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $name = $_POST['name'];
    $email = $_POST['email'];
    $class = $_POST['class'];

    // Update students.xml
    $student->name = $name;
    $student->email = $email;
    $student->class = $class;
    $studentsXml->save();

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
    <title>Modifier Étudiant</title>
    <link rel="stylesheet" href="../../../assets/css/style.css">
</head>
<body>
<div class="modal" id="editModal">
    <div class="modal-content">
        <a href="#" class="close" id="closeModal">&times;</a>
        <h2>✏ Modifier Étudiant</h2>
        <form method="post">
    Nom:<br>
    <input type="text" name="name" value="<?= htmlspecialchars($student->name) ?>" required>

    Email:<br>
    <input type="email" name="email" value="<?= htmlspecialchars($student->email) ?>" required>

    Classe:<br>
    <input type="text" name="class" value="<?= htmlspecialchars($student->class) ?>" required>

    <div class="form-buttons">
        <button type="submit" class="btn">Enregistrer</button>
        <a href="../dashboard.php" class="btn logout">Annuler</a>
    </div>
</form>

    </div>
</div>

</div>
<script>
    // Afficher automatiquement le modal au chargement
    document.getElementById("editModal").style.display = "block";

    // Fermer le modal en cliquant sur la croix
    document.getElementById("closeModal").onclick = function() {
        window.location.href = "../dashboard.php"; // retour au dashboard
    }

    // Fermer le modal en cliquant en dehors de la fenêtre
    window.onclick = function(event) {
        let modal = document.getElementById("editModal");
        if (event.target === modal) {
            window.location.href = "../dashboard.php";
        }
    }
</script>

</body>
</html>
