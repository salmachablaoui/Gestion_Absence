<?php
session_start();
require_once "../../../models/XmlManager.php";

// Vérifier que l'utilisateur est admin
if (!isset($_SESSION["user"]) || $_SESSION["user"]["role"] !== "admin") {
    header("Location: ../../../login.php");
    exit;
}

// Charger XML
$teachersXml = new XmlManager(__DIR__ . "/../../../data/teachers.xml");
$usersXml    = new XmlManager(__DIR__ . "/../../../data/users.xml");
$classesXml  = new XmlManager(__DIR__ . "/../../../data/classes.xml");

$classes = $classesXml->getAll()->class;

// Si formulaire soumis
if ($_SERVER["REQUEST_METHOD"] === "POST") {

    // Générer un ID unique
    $id = uniqid("u");

    // Récupérer les données POST
    $name   = htmlspecialchars($_POST["name"]);
    $email  = htmlspecialchars($_POST["email"]);
    $class  = htmlspecialchars($_POST["class"]);
    $module = htmlspecialchars($_POST["module"]);
    $password = $_POST["password"]; // Pour plus de sécurité : password_hash($password, PASSWORD_DEFAULT);

    // Ajouter dans teachers.xml
    $teacher = $teachersXml->getAll()->addChild("teacher");
    $teacher->addAttribute("id", $id);
    $teacher->addChild("name", $name);
    $teacher->addChild("email", $email);
    $teacher->addChild("class", $class);
    $teacher->addChild("module", $module);
    $teachersXml->save();

    // Ajouter dans users.xml
    $user = $usersXml->getAll()->addChild("user");
    $user->addAttribute("id", $id);
    $user->addAttribute("role", "teacher");
    $user->addChild("email", $email);
    $user->addChild("password", $password);
    $usersXml->save();

    // Redirection vers dashboard
    header("Location: ../dashboard.php");
    exit;
}
?>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Ajouter Enseignant</title>
</head>
<body>
<h2>➕ Ajouter Enseignant</h2>

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
// Mapping classes -> modules depuis PHP
const classModules = {
<?php foreach ($classes as $class): ?>
    "<?= $class['id'] ?>": [
        <?php foreach ($class->modules->module as $module): ?>
            "<?= addslashes($module) ?>",
        <?php endforeach; ?>
    ],
<?php endforeach; ?>
};

// Changer les modules selon la classe sélectionnée
document.getElementById("classSelect").addEventListener("change", function () {
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
