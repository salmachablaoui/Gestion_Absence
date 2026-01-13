<?php
session_start();
require_once "../../models/XmlManager.php";

if (!isset($_SESSION["user"]) || $_SESSION["user"]["role"] !== "admin") {
    header("Location: ../../login.php");
    exit;
}

$studentsXml = new XmlManager(__DIR__ . "/../../data/students.xml");
$teachersXml = new XmlManager(__DIR__ . "/../../data/teachers.xml");

$students = $studentsXml->getAll()->student;
$teachers = $teachersXml->getAll()->teacher;
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

    <!-- ➊ Actions -->
    <div class="actions">
        <button id="openAddStudent" class="btn">➕ Ajouter Étudiant</button>
        <button id="openAddTeacher" class="btn">➕ Ajouter Enseignant</button>
        <a href="../../logout.php" class="btn logout">🔒 Déconnexion</a>
    </div>

    <!-- ➋ Étudiants -->
    <h2>👨‍🎓 Étudiants</h2>
    <table>
        <tr>
            <th>ID</th>
            <th>Nom</th>
            <th>Email</th>
            <th>Classe</th>
            <th>Actions</th>
        </tr>
        <?php if($students): ?>
            <?php foreach($students as $student): ?>
                <tr>
                    <td><?= htmlspecialchars($student['id']) ?></td>
                    <td><?= htmlspecialchars($student->name) ?></td>
                    <td><?= htmlspecialchars($student->email) ?></td>
                    <td><?= htmlspecialchars($student->class) ?></td>
                    <td>
                        <a href="students/edit.php?id=<?= $student['id'] ?>" class="edit">✏ Modifier</a>
                        <a href="students/delete.php?id=<?= $student['id'] ?>" class="delete" onclick="return confirm('Supprimer cet étudiant ?')">🗑 Supprimer</a>
                    </td>
                </tr>
            <?php endforeach; ?>
        <?php else: ?>
            <tr><td colspan="5" style="text-align:center;">Aucun étudiant trouvé</td></tr>
        <?php endif; ?>
    </table>

    <!-- ➌ Enseignants -->
    <h2>👨‍🏫 Enseignants</h2>
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
                        <a href="teachers/edit.php?id=<?= $teacher['id'] ?>" class="edit">✏ Modifier</a>
                        <a href="teachers/delete.php?id=<?= $teacher['id'] ?>" class="delete" onclick="return confirm('Supprimer cet enseignant ?')">🗑 Supprimer</a>
                    </td>
                </tr>
            <?php endforeach; ?>
        <?php else: ?>
            <tr><td colspan="5" style="text-align:center;">Aucun enseignant trouvé</td></tr>
        <?php endif; ?>
    </table>
</div>

<!-- ================= Modal Ajouter Étudiant ================= -->
<div class="modal" id="addStudentModal">
    <div class="modal-content">
        <a href="#" class="close" id="closeAddStudent">&times;</a>
        <h2>➕ Ajouter Étudiant</h2>
        <form method="post" action="students/add.php">
            Nom:<br>
            <input type="text" name="name" required>

            Email:<br>
            <input type="email" name="email" required>

            Classe:<br>
            <input type="text" name="class" required>

            Mot de passe:<br>
            <input type="password" name="password" required>

            <div class="form-buttons">
                <button type="submit" class="btn">Ajouter</button>
                <button type="button" class="btn logout" id="cancelAddStudent">Annuler</button>
            </div>
        </form>
    </div>
</div>

<!-- ================= Modal Ajouter Enseignant ================= -->
<div class="modal" id="addTeacherModal">
    <div class="modal-content">
        <a href="#" class="close" id="closeAddTeacher">&times;</a>
        <h2>➕ Ajouter Enseignant</h2>
        <form method="post" action="teachers/add.php">
            Nom:<br>
            <input type="text" name="name" required>

            Email:<br>
            <input type="email" name="email" required>

            Module:<br>
            <input type="text" name="module" required>

            Mot de passe:<br>
            <input type="password" name="password" required>

            <div class="form-buttons">
                <button type="submit" class="btn">Ajouter</button>
                <button type="button" class="btn logout" id="cancelAddTeacher">Annuler</button>
            </div>
        </form>
    </div>
</div>

<!-- ================= JS pour ouvrir/fermer modals ================= -->
<script>
    // Étudiant
    let addStudentModal = document.getElementById("addStudentModal");
    document.getElementById("openAddStudent").onclick = function() { addStudentModal.style.display = "block"; }
    document.getElementById("closeAddStudent").onclick = function() { addStudentModal.style.display = "none"; }
    document.getElementById("cancelAddStudent").onclick = function() { addStudentModal.style.display = "none"; }

    // Enseignant
    let addTeacherModal = document.getElementById("addTeacherModal");
    document.getElementById("openAddTeacher").onclick = function() { addTeacherModal.style.display = "block"; }
    document.getElementById("closeAddTeacher").onclick = function() { addTeacherModal.style.display = "none"; }
    document.getElementById("cancelAddTeacher").onclick = function() { addTeacherModal.style.display = "none"; }

    // Fermer modals en cliquant en dehors
    window.onclick = function(event) {
        if(event.target === addStudentModal) addStudentModal.style.display = "none";
        if(event.target === addTeacherModal) addTeacherModal.style.display = "none";
    }
</script>

</body>
</html>
