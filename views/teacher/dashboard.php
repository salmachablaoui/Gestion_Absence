<?php
// views/teacher/dashboard.php
session_start();
require_once "../../models/XmlManager.php";

if (!isset($_SESSION["user"]) || $_SESSION["user"]["role"] !== "teacher") {
    header("Location: ../../login.php");
    exit;
}

$teacherId = $_SESSION["user"]["id"];
$basePath = "C:/xampp/htdocs/gestion-absences"; // Ajustez selon votre installation

// Chemins
$seancesXmlPath = $basePath . "/data/seances.xml";
$classesXmlPath = $basePath . "/data/classes.xml";
$studentsXmlPath = $basePath . "/data/students.xml";
$absencesXmlPath = $basePath . "/data/absences.xml";
$xslPath = $basePath . "/xslt/dashboard_teacher.xsl";

// Charger les XML
$xml = new DOMDocument();
$xml->load($seancesXmlPath);

$xsl = new DOMDocument();
$xsl->load($xslPath);

$proc = new XSLTProcessor();
$proc->importStylesheet($xsl);

// CORRECTION: Utiliser file:/// (TROIS slashes) pour Windows
$proc->setParameter('', 'teacherId', $teacherId);
$proc->setParameter('', 'studentsXmlPath', "file:///" . str_replace('\\', '/', $studentsXmlPath));
$proc->setParameter('', 'classesXmlPath', "file:///" . str_replace('\\', '/', $classesXmlPath));
$proc->setParameter('', 'absencesXmlPath', "file:///" . str_replace('\\', '/', $absencesXmlPath));

echo $proc->transformToXML($xml);