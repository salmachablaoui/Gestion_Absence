<?php
session_start();
require_once "../../models/XmlManager.php";

// Vérifier l'enseignant
if (!isset($_SESSION["user"]) || $_SESSION["user"]["role"] !== "teacher") {
    header("Location: ../../login.php");
    exit;
}

$teacherId = $_SESSION["user"]["id"];

$studentsXml = new XmlManager(__DIR__ . "/../../data/students.xml");
$students = $studentsXml->getAll()->student ?? [];

$seancesXml = new XmlManager(__DIR__ . "/../../data/seances.xml");
$seances = $seancesXml->getAll()->seance ?? [];

$classesXml = new XmlManager(__DIR__ . "/../../data/classes.xml");
$classes = $classesXml->getAll()->class ?? [];

$absencesXml = new XmlManager(__DIR__ . "/../../data/absences.xml");
$absences = $absencesXml->getAll()->absence ?? [];
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Enseignant</title>
    <link rel="stylesheet" href="../../assets/css/style.css">
</head>
<body>

<div class="container">
<h1>👨‍🏫 Dashboard Enseignant</h1>

<div class="actions">
    <button id="openAddSeance" class="btn">➕ Créer une séance</button>
    <a href="../../logout.php" class="btn logout">🔒 Déconnexion</a>
</div>

<h2>📅 Séances</h2>
<table>
<tr>
    <th>ID</th>
    <th>Classe</th>
    <th>Module</th>
    <th>Date & Heure</th>
    <th>Actions</th>
</tr>
<?php foreach ($seances as $seance): 
    if ((string)$seance->teacher_id !== $teacherId) continue; // juste les séances du prof
?>
<tr>
    <td><?= $seance['id'] ?></td>
    <td>
        <?php
        // Afficher le nom complet de la classe
        $className = "-";
        foreach ($classes as $class) {
            if ((string)$class['id'] === (string)$seance->class_id) {
                $className = htmlspecialchars($class->name);
                break;
            }
        }
        echo $className;
        ?>
    </td>
    <td><?= htmlspecialchars($seance->module) ?></td>
    <td><?= htmlspecialchars($seance->datetime) ?></td>
    <td>
        <button class="btn manageAbsenceBtn" data-seance-id="<?= $seance['id'] ?>">📋 Gérer l'absence</button>
    </td>
</tr>


  
<tr class="absenceTableRow" id="absenceTable_<?= $seance['id'] ?>" style="display:none;">
<td colspan="5">
<form method="post" action="mark_absence.php">
<table>
    <tr>
        <th>Nom</th>
        <th>Email</th>
        <th>Absent</th>
    </tr>
    <?php
    foreach ($students as $student) {
        if ((string)$student->class !== (string)$seance->class_id) continue;

        // Vérifier si absent déjà
        $isAbsent = false;
        foreach ($absences as $absence) {
            if ((string)$absence->studentId === (string)$student['id'] &&
                (string)$absence->seanceId === (string)$seance['id']) {
                $isAbsent = true;
                break;
            }
        }
    ?>
    <tr>
        <td><?= htmlspecialchars($student->name) ?></td>
        <td><?= htmlspecialchars($student->email) ?></td>
        <td>
            <input type="checkbox" name="absent_students[]" value="<?= $student['id'] ?>" <?= $isAbsent ? 'checked' : '' ?>>
            <label>Absent</label>
        </td>
    </tr>
    <?php } ?>
</table>
<input type="hidden" name="seance_id" value="<?= $seance['id'] ?>">
<button type="submit" class="btn">Enregistrer les absences</button>
</form>
</td>
</tr>


<?php endforeach; ?>
</table>

</div>

<script>
// Ouvrir / fermer tableau absence
document.querySelectorAll(".manageAbsenceBtn").forEach(btn => {
    btn.addEventListener("click", () => {
        const seanceId = btn.dataset.seanceId;
        const row = document.getElementById("absenceTable_" + seanceId);
        row.style.display = row.style.display === "none" ? "table-row" : "none";
    });
});
</script>

</body>
</html>
