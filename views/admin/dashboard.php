<?php
session_start();

// Vérifier que l'utilisateur est admin
if (!isset($_SESSION["user"]) || $_SESSION["user"]["role"] !== "admin") {
    header("Location: ../../login.php");
    exit;
}

// Charger le XML
$dashboard = new DOMDocument();
$dashboardXml = new DOMDocument();
$dashboardXml->load(__DIR__ . "/../../data/students.xml");
$studentsNode = $dashboard->importNode($dashboardXml->documentElement, true);

$teachersXml = new DOMDocument();
$teachersXml->load(__DIR__ . "/../../data/teachers.xml");
$teachersNode = $dashboard->importNode($teachersXml->documentElement, true);

$classesXml = new DOMDocument();
$classesXml->load(__DIR__ . "/../../data/classes.xml");
$classesNode = $dashboard->importNode($classesXml->documentElement, true);

// Créer le root <dashboard>
$root = $dashboard->createElement("dashboard");
$root->appendChild($studentsNode);
$root->appendChild($teachersNode);
$root->appendChild($classesNode);
$dashboard->appendChild($root);

// Charger le XSL
$xsl = new DOMDocument();
$xsl->load(__DIR__ . "/../../xslt/admin_dashboard.xsl");

$proc = new XSLTProcessor();
$proc->importStylesheet($xsl);

// Afficher le résultat
echo $proc->transformToXML($dashboard);
