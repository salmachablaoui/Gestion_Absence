<?php
// views/student/dashboard.php
session_start();

// Vérifier connexion et rôle
if (!isset($_SESSION["user"]) || $_SESSION["user"]["role"] !== "student") {
    header("Location: ../../login.php");
    exit;
}

$studentEmail = $_SESSION["user"]["email"];

// Chemin racine du projet
$basePath = dirname(dirname(dirname(__FILE__)));

// Chemins XML
$studentsXmlPath      = $basePath . "/data/students.xml";
$absencesXmlPath      = $basePath . "/data/absences.xml";
$teachersXmlPath      = $basePath . "/data/teachers.xml";
$notificationsXmlPath = $basePath . "/data/notifications.xml"; // ✅ AJOUT
$xslPath              = $basePath . "/xslt/dashboard_student.xsl";

// Vérification fichiers
$files = [
    $studentsXmlPath,
    $absencesXmlPath,
    $teachersXmlPath,
    $notificationsXmlPath,
    $xslPath
];

foreach ($files as $file) {
    if (!file_exists($file)) {
        die("<div style='color:red;padding:20px;'>Fichier manquant : $file</div>");
    }
}

// Charger le XSL
$xsl = new DOMDocument();
$xsl->load($xslPath);

// XML racine factice (le XSL utilise document())
$xml = new DOMDocument("1.0", "UTF-8");
$xml->appendChild($xml->createElement("dashboard"));

// Processeur XSLT
$proc = new XSLTProcessor();
$proc->importStylesheet($xsl);

// Passer les paramètres
$proc->setParameter('', 'studentEmail', $studentEmail);
$proc->setParameter('', 'studentsXmlPath',      "file:///" . str_replace('\\', '/', $studentsXmlPath));
$proc->setParameter('', 'absencesXmlPath',      "file:///" . str_replace('\\', '/', $absencesXmlPath));
$proc->setParameter('', 'teachersXmlPath',      "file:///" . str_replace('\\', '/', $teachersXmlPath));
$proc->setParameter('', 'notificationsXmlPath', "file:///" . str_replace('\\', '/', $notificationsXmlPath)); // ✅ AJOUT CRUCIAL

// Affichage final
echo $proc->transformToXML($xml);
