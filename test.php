<?php
// check_data.php à la racine
echo "<h2>Vérification des données</h2>";

$basePath = dirname(__FILE__);

// 1. Vérifier students.xml
echo "<h3>1. Fichier students.xml</h3>";
$studentsFile = $basePath . "/data/students.xml";
if (file_exists($studentsFile)) {
    $students = simplexml_load_file($studentsFile);
    echo "<pre>";
    print_r($students);
    echo "</pre>";
    
    // Vérifier la structure
    echo "<h4>Liste des étudiants:</h4>";
    foreach ($students->student as $student) {
        echo "ID: " . $student['id'] . "<br>";
        echo "Nom: " . $student->name . "<br>";
        echo "Email: " . $student->email . "<br>";
        echo "Classe: " . $student->class . "<br>";
        echo "<hr>";
    }
} else {
    echo "❌ Fichier non trouvé: $studentsFile";
}

// 2. Vérifier l'email de session
echo "<h3>2. Session utilisateur</h3>";
session_start();
if (isset($_SESSION["user"])) {
    echo "<pre>";
    print_r($_SESSION["user"]);
    echo "</pre>";
} else {
    echo "❌ Aucun utilisateur en session";
}

// 3. Vérifier absences.xml
echo "<h3>3. Fichier absences.xml</h3>";
$absencesFile = $basePath . "/data/absences.xml";
if (file_exists($absencesFile)) {
    $absences = simplexml_load_file($absencesFile);
    echo "<pre>";
    print_r($absences);
    echo "</pre>";
    
    echo "<h4>Nombre d'absences: " . count($absences->absence) . "</h4>";
} else {
    echo "❌ Fichier non trouvé";
}

// 4. Vérifier student_notifications.xml
echo "<h3>4. Fichier student_notifications.xml</h3>";
$notifFile = $basePath . "/data/student_notifications.xml";
if (file_exists($notifFile)) {
    $notifs = simplexml_load_file($notifFile);
    echo "<pre>";
    print_r($notifs);
    echo "</pre>";
}
?>