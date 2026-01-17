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
    $password = $_POST["password"]; // ou password_hash($password, PASSWORD_DEFAULT)

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
    <link rel="stylesheet" href="../../../assets/css/style.css">
</head>
<body>

<!-- MODAL -->
<div class="modal" id="addTeacherModal">
    <div class="modal-content">
        <a href="../dashboard.php" class="close" id="closeModal">&times;</a>
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

            <div class="form-buttons">
                <button type="submit" class="btn">Ajouter</button>
                <a href="../dashboard.php" class="btn logout">Annuler</a>
            </div>
        </form>
    </div>
</div>

<script>
// Afficher automatiquement le modal
document.getElementById("addTeacherModal").style.display = "block";

// Fermer le modal avec la croix
document.getElementById("closeModal").onclick = function() {
    window.location.href = "../dashboard.php";
};

// Fermer en cliquant à l’extérieur
window.onclick = function(event) {
    const modal = document.getElementById("addTeacherModal");
    if (event.target === modal) {
        window.location.href = "../dashboard.php";
    }
};

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