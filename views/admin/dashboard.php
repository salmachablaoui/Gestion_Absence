<?php
session_start();
require_once "../../models/XmlManager.php";

// Vérifier que l'utilisateur est admin
if (!isset($_SESSION["user"]) || $_SESSION["user"]["role"] !== "admin") {
    header("Location: ../../login.php");
    exit;
}

// Chargement des XML
$studentsXml = new XmlManager(__DIR__ . "/../../data/students.xml");
$teachersXml = new XmlManager(__DIR__ . "/../../data/teachers.xml");
$classesXml  = new XmlManager(__DIR__ . "/../../data/classes.xml");

$students = $studentsXml->getAll()->student;
$teachers = $teachersXml->getAll()->teacher;
$classes  = $classesXml->getAll()->class;
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Admin</title>
    <link rel="stylesheet" href="../../assets/css/style.css">
</head>
<body>

<div class="container">
    <h1>🛠 Dashboard Admin</h1>

    <!-- Actions -->
    <div class="actions">
        <button id="openAddStudent" class="btn">➕ Ajouter Étudiant</button>
        <button id="openAddTeacher" class="btn">➕ Ajouter Enseignant</button>
        <a href="../../logout.php" class="btn logout">🔒 Déconnexion</a>
    </div>

    <!-- ================= ÉTUDIANTS ================= -->
    <h2>👨‍🎓 Étudiants</h2>
    <table>
        <tr>
            <th>ID</th>
            <th>Nom</th>
            <th>Email</th>
            <th>Classe</th>
            <th>Module</th>
            <th>Actions</th>
        </tr>
        <?php if ($students): foreach ($students as $student): ?>
            <tr>
                <td><?= htmlspecialchars($student['id']) ?></td>
                <td><?= htmlspecialchars($student->name) ?></td>
                <td><?= htmlspecialchars($student->email) ?></td>
                <td><?= htmlspecialchars($student->class) ?></td>
                <td><?= htmlspecialchars($student->module ?? '-') ?></td>
                <td>
                    <a href="students/edit.php?id=<?= $student['id'] ?>" class="edit">✏</a>
                    <a href="students/delete.php?id=<?= $student['id'] ?>" class="delete"
                       onclick="return confirm('Supprimer cet étudiant ?')">🗑</a>
                </td>
            </tr>
        <?php endforeach; else: ?>
            <tr><td colspan="6" style="text-align:center;">Aucun étudiant</td></tr>
        <?php endif; ?>
    </table>

    <!-- ================= ENSEIGNANTS ================= -->
    <h2>👨‍🏫 Enseignants</h2>
    <table>
        <tr>
            <th>ID</th>
            <th>Nom</th>
            <th>Email</th>
            <th>Classe</th>
            <th>Module</th>
            <th>Actions</th>
        </tr>
        <?php if ($teachers): foreach ($teachers as $teacher): ?>
            <tr>
                <td><?= htmlspecialchars($teacher['id']) ?></td>
                <td><?= htmlspecialchars($teacher->name) ?></td>
                <td><?= htmlspecialchars($teacher->email) ?></td>
                <td><?= htmlspecialchars($teacher->class ?? '-') ?></td>
                <td><?= htmlspecialchars($teacher->module) ?></td>
                <td>
                    <a href="teachers/edit.php?id=<?= $teacher['id'] ?>" class="edit">✏</a>
                    <a href="teachers/delete.php?id=<?= $teacher['id'] ?>" class="delete"
                       onclick="return confirm('Supprimer cet enseignant ?')">🗑</a>
                </td>
            </tr>
        <?php endforeach; else: ?>
            <tr><td colspan="6" style="text-align:center;">Aucun enseignant</td></tr>
        <?php endif; ?>
    </table>
</div>

<!-- ================= MODAL AJOUT ÉTUDIANT ================= -->
<div class="modal" id="addStudentModal">
    <div class="modal-content">
        <span class="close" id="closeAddStudent">&times;</span>
        <h2>➕ Ajouter Étudiant</h2>

        <form method="post" action="students/add.php">
            <label>Nom :</label>
            <input type="text" name="name" required>

            <label>Email :</label>
            <input type="email" name="email" required>

            <label>Classe :</label>
            <select name="class" id="classSelect" required>
                <option value="">-- Choisir --</option>
                <?php foreach ($classes as $class): ?>
                    <option value="<?= $class['id'] ?>">
                        <?= htmlspecialchars($class->name) ?>
                    </option>
                <?php endforeach; ?>
            </select>

            <label>Module :</label>
            <select name="module" id="moduleSelect" required>
                <option value="">-- Choisir --</option>
            </select>

            <label>Mot de passe :</label>
            <input type="password" name="password" required>

            <div class="form-buttons">
                <button type="submit" class="btn">Ajouter</button>
                <button type="button" class="btn logout" id="cancelAddStudent">Annuler</button>
            </div>
        </form>
    </div>
</div>

<!-- ================= MODAL AJOUT ENSEIGNANT ================= -->
<div class="modal" id="addTeacherModal">
    <div class="modal-content">
        <span class="close" id="closeAddTeacher">&times;</span>
        <h2>➕ Ajouter Enseignant</h2>

        <form method="post" action="teachers/add.php">
            <label>Nom :</label>
            <input type="text" name="name" required>

            <label>Email :</label>
            <input type="email" name="email" required>

            <label>Classe :</label>
            <select name="class" id="teacherClassSelect" required>
                <option value="">-- Choisir --</option>
                <?php foreach ($classes as $class): ?>
                    <option value="<?= $class['id'] ?>">
                        <?= htmlspecialchars($class->name) ?>
                    </option>
                <?php endforeach; ?>
            </select>

            <label>Module :</label>
            <select name="module" id="teacherModuleSelect" required>
                <option value="">-- Choisir --</option>
            </select>

            <label>Mot de passe :</label>
            <input type="password" name="password" required>

            <div class="form-buttons">
                <button type="submit" class="btn">Ajouter</button>
                <button type="button" class="btn logout" id="cancelAddTeacher">Annuler</button>
            </div>
        </form>
    </div>
</div>

<!-- ================= JS ================= -->
<script>
// Gestion des modals
const addStudentModal = document.getElementById("addStudentModal");
const addTeacherModal = document.getElementById("addTeacherModal");

document.getElementById("openAddStudent").onclick = () => addStudentModal.style.display = "block";
document.getElementById("openAddTeacher").onclick = () => addTeacherModal.style.display = "block";
document.getElementById("closeAddStudent").onclick = () => addStudentModal.style.display = "none";
document.getElementById("closeAddTeacher").onclick = () => addTeacherModal.style.display = "none";
document.getElementById("cancelAddStudent").onclick = () => addStudentModal.style.display = "none";
document.getElementById("cancelAddTeacher").onclick = () => addTeacherModal.style.display = "none";

window.onclick = e => {
    if (e.target === addStudentModal) addStudentModal.style.display = "none";
    if (e.target === addTeacherModal) addTeacherModal.style.display = "none";
};

// Mapping classes -> modules
const classModules = {
<?php foreach ($classes as $class): ?>
    "<?= $class['id'] ?>": [
        <?php foreach ($class->modules->module as $module): ?>
            "<?= addslashes($module) ?>",
        <?php endforeach; ?>
    ],
<?php endforeach; ?>
};

// Étudiant : changer module selon classe
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

// Enseignant : changer module selon classe
document.getElementById("teacherClassSelect").addEventListener("change", function () {
    const moduleSelect = document.getElementById("teacherModuleSelect");
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
