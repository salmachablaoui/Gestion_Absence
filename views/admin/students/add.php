<?php
session_start();
require_once "../../../models/XmlManager.php";

if (!isset($_SESSION["user"]) || $_SESSION["user"]["role"] !== "admin") {
    header("Location: ../../../login.php");
    exit;
}

$studentsXml = new XmlManager(__DIR__ . "/../../../data/students.xml");
$usersXml    = new XmlManager(__DIR__ . "/../../../data/users.xml");
$classesXml  = new XmlManager(__DIR__ . "/../../../data/classes.xml");
$classes = $classesXml->getAll()->class;

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $id = uniqid("u");
    $student = $studentsXml->getAll()->addChild("student");
    $student->addAttribute("id", $id);
    $student->addChild("name", htmlspecialchars($_POST["name"]));
    $student->addChild("email", htmlspecialchars($_POST["email"]));
    $student->addChild("class", htmlspecialchars($_POST["class"]));
    $student->addChild("module", htmlspecialchars($_POST["module"]));
    $studentsXml->save();

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
</head>
<body>
<h2>➕ Ajouter Étudiant</h2>
<form method="post" action="">
    <label>Nom :</label>
    <input type="text" name="name" required><br><br>

    <label>Email :</label>
    <input type="email" name="email" required><br><br>

    <label>Classe :</label>
    <select name="class" id="classSelect" required>
        <option value="">-- Choisir --</option>
        <?php foreach ($classes as $class): ?>
            <option value="<?= $class['id'] ?>"><?= htmlspecialchars($class->name) ?></option>
        <?php endforeach; ?>
    </select><br><br>

    <label>Module :</label>
    <select name="module" id="moduleSelect" required>
        <option value="">-- Choisir --</option>
    </select><br><br>

    <label>Mot de passe :</label>
    <input type="password" name="password" required><br><br>

    <button type="submit">Ajouter</button>
</form>

<script>
// Créer un mapping classe -> modules depuis le XML PHP
const classModules = {
<?php foreach ($classes as $class): ?>
    "<?= $class['id'] ?>": [
        <?php 
        if (isset($class->modules->module)) {
            foreach ($class->modules->module as $module) {
                echo '"' . addslashes($module) . '",';
            }
        }
        ?>
    ],
<?php endforeach; ?>
};

// Quand on change la classe, mettre à jour les modules
document.getElementById("classSelect").addEventListener("change", function() {
    const moduleSelect = document.getElementById("moduleSelect");
    moduleSelect.innerHTML = '<option value="">-- Choisir --</option>';
    (classModules[this.value] || []).forEach(m => {
        const opt = document.createElement("option");
        opt.value = m;
        opt.textContent = m;
        moduleSelect.appendChild(opt);
    });
});
</script>
</body>
</html>
