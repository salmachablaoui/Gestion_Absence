<?php
session_start();
if (!isset($_SESSION["user"]) || $_SESSION["user"]["role"] !== "teacher") {
    header("Location: ../../login.php");
    exit;
}

// Base path
$basePath = "C:/xampp/htdocs/gestion-absences";

// XML / XSL paths
$seancesXmlPath  = $basePath . "/data/seances.xml";
$classesXmlPath  = $basePath . "/data/classes.xml";
$studentsXmlPath = $basePath . "/data/students.xml";
$absencesXmlPath = $basePath . "/data/absences.xml";
$teachersXmlPath = $basePath . "/data/teachers.xml";
$xslPath         = $basePath . "/xslt/dashboard_teacher.xsl";

// Charger les XML
$xml = new DOMDocument();
$xml->load($seancesXmlPath);

// Charger XSL
$xsl = new DOMDocument();
$xsl->load($xslPath);

// Créer le processeur XSLT
$proc = new XSLTProcessor();
$proc->importStylesheet($xsl);

// Récupérer le module de l'enseignant
$teacherId = trim($_SESSION["user"]["id"]);
$teachersXml = new DOMDocument();
$teachersXml->load($teachersXmlPath);
$xpath = new DOMXPath($teachersXml);
$teacherNode = $xpath->query("/teachers/teacher[@id='{$teacherId}']")->item(0);
$teacherModule = $teacherNode ? $teacherNode->getElementsByTagName("module")[0]->nodeValue : "Module par défaut";

// Passer les paramètres au XSLT
$proc->setParameter('', 'teacherId', $teacherId);
$proc->setParameter('', 'teacherModule', $teacherModule);
$proc->setParameter('', 'studentsXmlPath', "file:///" . str_replace('\\', '/', $studentsXmlPath));
$proc->setParameter('', 'classesXmlPath', "file:///" . str_replace('\\', '/', $classesXmlPath));
$proc->setParameter('', 'absencesXmlPath', "file:///" . str_replace('\\', '/', $absencesXmlPath));
$proc->setParameter('', 'teachersXmlPath', "file:///" . str_replace('\\', '/', $teachersXmlPath));

// Transformer et afficher
echo $proc->transformToXML($xml);
?>
