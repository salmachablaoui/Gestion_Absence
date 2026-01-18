<?php
session_start();
require_once "../../models/XmlManager.php";

if (!isset($_SESSION["user"]) || $_SESSION["user"]["role"] !== "teacher") {
    header("Location: ../../login.php");
    exit;
}

$teacherId = trim($_SESSION["user"]["id"]);

$basePath = "C:/xampp/htdocs/gestion-absences";

// chemins XML / XSL
$seancesXmlPath  = $basePath . "/data/seances.xml";
$classesXmlPath  = $basePath . "/data/classes.xml";
$studentsXmlPath = $basePath . "/data/students.xml";
$absencesXmlPath = $basePath . "/data/absences.xml";
$xslPath         = $basePath . "/xslt/dashboard_teacher.xsl";

// charger seances.xml
$xml = new DOMDocument();
$xml->load($seancesXmlPath);

// charger XSL
$xsl = new DOMDocument();
$xsl->load($xslPath);

$proc = new XSLTProcessor();
$proc->importStylesheet($xsl);

// paramètres XSL
$proc->setParameter('', 'teacherId', $teacherId);
$proc->setParameter('', 'studentsXmlPath', "file:///" . str_replace('\\', '/', $studentsXmlPath));
$proc->setParameter('', 'classesXmlPath', "file:///" . str_replace('\\', '/', $classesXmlPath));
$proc->setParameter('', 'absencesXmlPath', "file:///" . str_replace('\\', '/', $absencesXmlPath));

echo $proc->transformToXML($xml);
