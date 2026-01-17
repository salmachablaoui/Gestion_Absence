<?php
// views/student/dashboard.php
session_start();

if (!isset($_SESSION["user"]) || $_SESSION["user"]["role"] !== "student") {
    header("Location: ../../login.php");
    exit;
}

$studentId = $_SESSION["user"]["id"];
$studentEmail = $_SESSION["user"]["email"];
$studentName = $_SESSION["user"]["name"] ?? 'Étudiant';

$basePath = dirname(__DIR__, 2);

// Charger les données XML directement dans PHP
$studentsXml = simplexml_load_file($basePath . "/data/students.xml");
$absencesXml = simplexml_load_file($basePath . "/data/absences.xml");
$teachersXml = simplexml_load_file($basePath . "/data/teachers.xml");
$seancesXml = simplexml_load_file($basePath . "/data/seances.xml");
$notificationsXml = simplexml_load_file($basePath . "/data/student_notifications.xml");

// Trouver les données de l'étudiant
$studentData = null;
foreach ($studentsXml->student as $student) {
    if ((string)$student['id'] === $studentId) {
        $studentData = $student;
        break;
    }
}

// Compter les absences de l'étudiant
$absencesCount = 0;
foreach ($absencesXml->absence as $absence) {
    if ((string)$absence->studentId === $studentId) {
        $absencesCount++;
    }
}

// Compter les notifications de l'étudiant
$notificationsCount = 0;
foreach ($notificationsXml->notification as $notification) {
    if ((string)$notification->student_id === $studentId) {
        $notificationsCount++;
    }
}

// Créer un XML avec TOUTES les données intégrées
$xmlContent = '<?xml version="1.0" encoding="UTF-8"?>
<dashboard>
    <student>
        <id>' . htmlspecialchars($studentId) . '</id>
        <email>' . htmlspecialchars($studentEmail) . '</email>
        <name>' . htmlspecialchars($studentData ? $studentData->name : $studentName) . '</name>
        <class>' . htmlspecialchars($studentData ? $studentData->class : 'Non spécifié') . '</class>
    </student>
    
    <statistics>
        <absences>' . $absencesCount . '</absences>
        <notifications>' . $notificationsCount . '</notifications>
    </statistics>
    
    <!-- Intégrer les absences directement -->
    <absences>';
    
foreach ($absencesXml->absence as $absence) {
    if ((string)$absence->studentId === $studentId) {
        $xmlContent .= '
        <absence>
            <date>' . htmlspecialchars($absence->date) . '</date>
            <hours>' . htmlspecialchars($absence->hours) . '</hours>
            <module>' . htmlspecialchars($absence->module) . '</module>
            <status>' . htmlspecialchars($absence->status) . '</status>
            <seanceId>' . htmlspecialchars($absence->seanceId) . '</seanceId>
        </absence>';
    }
}

$xmlContent .= '
    </absences>
    
    <!-- Intégrer les notifications directement -->
    <notifications>';
    
foreach ($notificationsXml->notification as $notification) {
    if ((string)$notification->student_id === $studentId) {
        $xmlContent .= '
        <notification>
            <message>' . htmlspecialchars($notification->message) . '</message>
            <date>' . htmlspecialchars($notification->date) . '</date>
        </notification>';
    }
}

$xmlContent .= '
    </notifications>
</dashboard>';

// Charger le XSLT
$xslPath = $basePath . "/xslt/dashboard_student.xsl";
if (!file_exists($xslPath)) {
    // Si pas de XSLT, afficher directement
    header('Content-Type: text/html; charset=utf-8');
    echo '<!DOCTYPE html>
    <html>
    <head><title>Dashboard</title></head>
    <body>
        <h1>Dashboard Direct</h1>
        <pre>' . htmlspecialchars($xmlContent) . '</pre>
    </body>
    </html>';
    exit;
}

$xsl = new DOMDocument();
$xsl->load($xslPath);

$xml = new DOMDocument();
$xml->loadXML($xmlContent);

$proc = new XSLTProcessor();
$proc->importStylesheet($xsl);

// Passer les paramètres
$proc->setParameter('', 'studentId', $studentId);
$proc->setParameter('', 'studentEmail', $studentEmail);

echo $proc->transformToXML($xml);
?>