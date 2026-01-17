<?php
// views/teacher/dashboard.php
session_start();

if (!isset($_SESSION["user"]) || $_SESSION["user"]["role"] !== "teacher") {
    header("Location: ../../login.php");
    exit;
}

$teacherId = $_SESSION["user"]["id"];

// Configuration
$basePath = "C:/xampp1/htdocs/Gestion_Absence";
$seancesXmlPath = $basePath . "/data/seances.xml";
$xslPath = $basePath . "/xslt/dashboard_teacher.xsl";

// Débogage initial (à commenter après vérification)
echo "<!-- DEBUG INFO -->";
echo "<!-- Teacher ID: $teacherId -->";
echo "<!-- Seances XML Path: $seancesXmlPath -->";
echo "<!-- Seances XML Exists: " . (file_exists($seancesXmlPath) ? 'YES' : 'NO') . " -->";

if (file_exists($seancesXmlPath)) {
    $content = file_get_contents($seancesXmlPath);
    echo "<!-- Seances XML Content (first 500 chars): " . htmlspecialchars(substr($content, 0, 500)) . " -->";
}

// Charger le XML
$xml = new DOMDocument();
if (!$xml->load($seancesXmlPath)) {
    die("❌ Erreur: Impossible de charger le fichier XML des séances");
}

// Charger le XSL
$xsl = new DOMDocument();
if (!$xsl->load($xslPath)) {
    die("❌ Erreur: Impossible de charger le fichier XSL");
}

// Créer le processeur
$proc = new XSLTProcessor();
$proc->importStylesheet($xsl);

// Définir les chemins avec file://
$proc->setParameter('', 'teacherId', $teacherId);
$proc->setParameter('', 'studentsXmlPath', "file:///" . str_replace('\\', '/', $basePath) . "/data/students.xml");
$proc->setParameter('', 'classesXmlPath', "file:///" . str_replace('\\', '/', $basePath) . "/data/classes.xml");
$proc->setParameter('', 'absencesXmlPath', "file:///" . str_replace('\\', '/', $basePath) . "/data/absences.xml");
$proc->setParameter('', 'seancesXmlPath', "file:///" . str_replace('\\', '/', $basePath) . "/data/seances.xml");

// Exécuter la transformation
$result = $proc->transformToXML($xml);

if ($result === false) {
    echo "<h2>❌ Erreur XSLT</h2>";
    echo "<p>La transformation XSLT a échoué.</p>";
    
    // Informations supplémentaires
    $errors = libxml_get_errors();
    if (!empty($errors)) {
        echo "<h3>Erreurs XML/XSL :</h3>";
        foreach ($errors as $error) {
            echo "<p>Ligne $error->line : $error->message</p>";
        }
        libxml_clear_errors();
    }
} else {
    echo $result;
}
?>