<?php
session_start();
require_once "../../../models/XmlManager.php";

// Sécurité : admin seulement
if (!isset($_SESSION["user"]) || $_SESSION["user"]["role"] !== "admin") {
    header("Location: ../../../login.php");
    exit;
}

// Vérifier ID
if (!isset($_GET['id'])) {
    header("Location: ../dashboard.php");
    exit;
}

$id = $_GET['id'];

$studentsXml = new XmlManager(__DIR__ . "/../../../data/students.xml");
$usersXml    = new XmlManager(__DIR__ . "/../../../data/users.xml");
$classesXml  = new XmlManager(__DIR__ . "/../../../data/classes.xml");

$classes = $classesXml->getAll()->class;

// Chercher l’étudiant
$student = null;
foreach ($studentsXml->getAll()->student as $s) {
    if ((string)$s['id'] === $id) {
        $student = $s;
        break;
    }
}

if (!$student) {
    header("Location: ../dashboard.php");
    exit;
}

// Traitement update
if ($_SERVER["REQUEST_METHOD"] === "POST") {

    $student->name  = htmlspecialchars($_POST['name']);
    $student->email = htmlspecialchars($_POST['email']);
    $student->class = htmlspecialchars($_POST['class']);
    $studentsXml->save();

    // Update users.xml (email seulement)
    foreach ($usersXml->getAll()->user as $user) {
        if ((string)$user['id'] === $id) {
            $user->email = htmlspecialchars($_POST['email']);
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

            <label>Nom :</label><br>
            <input type="text" name="name"
                   value="<?= htmlspecialchars($student->name) ?>" required><br><br>

            <label>Email :</label><br>
            <input type="email" name="email"
                   value="<?= htmlspecialchars($student->email) ?>" required><br><br>

            <label>Classe :</label><br>
            <select name="class" required>
                <?php foreach ($classes as $class): ?>
                    <option value="<?= $class['id'] ?>"
                        <?= ($student->class == $class['id']) ? "selected" : "" ?>>
                        <?= htmlspecialchars($class->name) ?>
                    </option>
                <?php endforeach; ?>
            </select><br><br>

            <div class="form-buttons">
                <button type="submit" class="btn">Enregistrer</button>
                <a href="../dashboard.php" class="btn logout">Annuler</a>
            </div>

        </form>
    </div>
</div>

<script>
document.getElementById("editModal").style.display = "block";

document.getElementById("closeModal").onclick = function () {
    window.location.href = "../dashboard.php";
};

window.onclick = function (event) {
    const modal = document.getElementById("editModal");
    if (event.target === modal) {
        window.location.href = "../dashboard.php";
    }
};
</script>

</body>
</html>