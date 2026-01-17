<?php
session_start();
require_once "../../../models/XmlManager.php";

// Sécurité : admin uniquement
if (!isset($_SESSION["user"]) || $_SESSION["user"]["role"] !== "admin") {
    header("Location: ../../../login.php");
    exit;
}

// Chargement des XML
$studentsXml = new XmlManager(__DIR__ . "/../../../data/students.xml");
$usersXml    = new XmlManager(__DIR__ . "/../../../data/users.xml");
$classesXml  = new XmlManager(__DIR__ . "/../../../data/classes.xml");

$classes = $classesXml->getAll()->class;

// Traitement ajout
if ($_SERVER["REQUEST_METHOD"] === "POST") {

    $id = uniqid("u");

    // ➕ students.xml
    $student = $studentsXml->getAll()->addChild("student");
    $student->addAttribute("id", $id);
    $student->addChild("name", htmlspecialchars($_POST["name"]));
    $student->addChild("email", htmlspecialchars($_POST["email"]));
    $student->addChild("class", htmlspecialchars($_POST["class"]));
    $studentsXml->save();

    // ➕ users.xml
    $user = $usersXml->getAll()->addChild("user");
    $user->addAttribute("id", $id);
    $user->addAttribute("role", "student");
    $user->addChild("email", htmlspecialchars($_POST["email"]));
    $user->addChild("password", password_hash($_POST["password"], PASSWORD_DEFAULT));
    $usersXml->save();

    header("Location: ../dashboard.php");
    exit;
}
?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Ajouter Étudiant</title>
    <link rel="stylesheet" href="../../../assets/css/style.css">
</head>
<body>

<!-- MODAL -->
<div class="modal" id="addModal">
    <div class="modal-content">
        <a href="#" class="close" id="closeModal">&times;</a>
        <h2>➕ Ajouter Étudiant</h2>

        <form method="post">

            <label>Nom :</label><br>
            <input type="text" name="name" required><br><br>

            <label>Email :</label><br>
            <input type="email" name="email" required><br><br>

            <label>Classe :</label><br>
            <select name="class" required>
                <option value="">-- Choisir --</option>
                <?php foreach ($classes as $class): ?>
                    <option value="<?= $class['id'] ?>">
                        <?= htmlspecialchars($class->name) ?>
                    </option>
                <?php endforeach; ?>
            </select><br><br>

            <label>Mot de passe :</label><br>
            <input type="password" name="password" required><br><br>

            <div class="form-buttons">
                <button type="submit" class="btn">Ajouter</button>
                <a href="../dashboard.php" class="btn logout">Annuler</a>
            </div>

        </form>
    </div>
</div>

<script>
// Afficher automatiquement le modal
document.getElementById("addModal").style.display = "block";

// Fermer avec la croix
document.getElementById("closeModal").onclick = function () {
    window.location.href = "../dashboard.php";
};

// Fermer en cliquant à l’extérieur
window.onclick = function (event) {
    const modal = document.getElementById("addModal");
    if (event.target === modal) {
        window.location.href = "../dashboard.php";
    }
};
</script>

</body>
</html>