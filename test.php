<?php
// test.php - Script de test avec chemin absolu
header('Content-Type: text/html; charset=utf-8');

// Définir le chemin ABSOLU
$basePath = __DIR__ . '/data/';

echo "<h2>Test du système de notifications</h2>";
echo "<p>Chemin de base: " . $basePath . "</p>";

// Vérifier que les fichiers existent
$studentsFile = $basePath . 'students.xml';
$seancesFile = $basePath . 'seances.xml';
$notificationsFile = $basePath . 'student_notifications.xml';

echo "<h3>Vérification des fichiers:</h3>";
echo "<ul>";
echo "<li>students.xml: " . (file_exists($studentsFile) ? "✓ Existe" : "✗ Manquant") . "</li>";
echo "<li>seances.xml: " . (file_exists($seancesFile) ? "✓ Existe" : "✗ Manquant") . "</li>";
echo "<li>student_notifications.xml: " . (file_exists($notificationsFile) ? "✓ Existe" : "✗ Manquant") . "</li>";
echo "</ul>";

if (!file_exists($studentsFile)) {
    die("<p style='color: red;'>Fichier students.xml introuvable!</p>");
}

// Charger les classes
require_once "observer/AbsenceManager.php";
require_once "observer/DashboardNotifier.php";
require_once "observer/StudentNotifier.php";

try {
    // Créer le manager avec chemin absolu
    $manager = new AbsenceManager($basePath);
    
    // Attacher les notifiers
    $dashboardNotifier = new DashboardNotifier("DashboardNotifier", $basePath);
    $studentNotifier = new StudentNotifier("StudentNotifier", $basePath);
    
    $manager->attach($dashboardNotifier);
    $manager->attach($studentNotifier);
    
    echo "<h3>Tentative d'enregistrement d'absence...</h3>";
    
    // Tester avec des données
    $result = $manager->markAbsence(
        "u696949b014b8f",  // ID étudiant existant
        "SE696bbbdc134a8", // ID séance existante
        "u6966b377b822d",  // ID enseignant
        "Base de données", // Module
        date("Y-m-d H:i:s") // Date
    );
    
    echo "<h4>Résultat :</h4>";
    echo "<pre>";
    print_r($result);
    echo "</pre>";
    
    // Vérifier si le fichier a été créé/modifié
    if (file_exists($notificationsFile)) {
        echo "<h4>Contenu de student_notifications.xml :</h4>";
        $xmlContent = file_get_contents($notificationsFile);
        echo "<textarea style='width: 100%; height: 300px;'>" . 
             htmlspecialchars($xmlContent) . 
             "</textarea>";
        
        // Vérifier aussi le contenu XML
        $xml = simplexml_load_file($notificationsFile);
        $notifications = $xml->xpath('//notification[student_id="u696949b014b8f"]');
        echo "<p>Notifications pour cet étudiant: " . count($notifications) . "</p>";
    } else {
        echo "<p style='color: red;'>Fichier student_notifications.xml non créé!</p>";
        
        // Essayer de créer manuellement
        $xml = new SimpleXMLElement('<?xml version="1.0" encoding="UTF-8"?><notifications></notifications>');
        if ($xml->asXML($notificationsFile)) {
            echo "<p>Fichier créé manuellement. Réessayez le test.</p>";
        } else {
            echo "<p style='color: red;'>Impossible de créer le fichier. Vérifiez les permissions.</p>";
        }
    }
    
} catch (Exception $e) {
    echo "<div style='background: #ffcccc; padding: 20px; border: 1px solid red;'>";
    echo "<h3>ERREUR :</h3>";
    echo "<p><strong>" . htmlspecialchars($e->getMessage()) . "</strong></p>";
    echo "<p>Fichier: " . $e->getFile() . " (ligne " . $e->getLine() . ")</p>";
    echo "<p>Trace :</p>";
    echo "<pre>" . $e->getTraceAsString() . "</pre>";
    echo "</div>";
}

// Vérifier les permissions
echo "<h3>Permissions des fichiers :</h3>";
echo "<ul>";
echo "<li>students.xml: " . substr(sprintf('%o', fileperms($studentsFile)), -4) . "</li>";
echo "<li>Dossier data: " . substr(sprintf('%o', fileperms($basePath)), -4) . "</li>";
echo "</ul>";
?>