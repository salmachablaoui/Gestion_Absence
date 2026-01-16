<?php
// views/student/dashboard.php
session_start();
require_once "../../models/XmlManager.php";

// Vérifier connexion et rôle
if (!isset($_SESSION["user"]) || $_SESSION["user"]["role"] !== "student") {
    header("Location: ../../login.php");
    exit;
}

$studentEmail = $_SESSION["user"]["email"];

// Chemin de base
$basePath = dirname(dirname(dirname(__FILE__)));

// Chemins des fichiers XML
$studentsXmlPath = $basePath . "/data/students.xml";
$absencesXmlPath = $basePath . "/data/absences.xml";
$teachersXmlPath = $basePath . "/data/teachers.xml";
$xslPath = $basePath . "/xslt/dashboard_student.xsl";

// Vérifier que les fichiers existent
if (!file_exists($studentsXmlPath) || !file_exists($absencesXmlPath) || !file_exists($teachersXmlPath) || !file_exists($xslPath)) {
    die("<div style='color:red;padding:20px;'>Fichiers manquants. Contactez l'administrateur.</div>");
}

// Charger le XSLT
$xsl = new DOMDocument();
$xsl->load($xslPath);

// Créer un XML simple pour le template
$xml = new DOMDocument('1.0', 'UTF-8');
$root = $xml->createElement('dashboard');
$xml->appendChild($root);

// Transformer
$proc = new XSLTProcessor();
$proc->importStylesheet($xsl);

// Passer les paramètres avec file:/// (trois slashes) pour Windows
$proc->setParameter('', 'studentEmail', $studentEmail);
$proc->setParameter('', 'studentsXmlPath', "file:///" . str_replace('\\', '/', $studentsXmlPath));
$proc->setParameter('', 'absencesXmlPath', "file:///" . str_replace('\\', '/', $absencesXmlPath));
$proc->setParameter('', 'teachersXmlPath', "file:///" . str_replace('\\', '/', $teachersXmlPath));

echo $proc->transformToXML($xml);