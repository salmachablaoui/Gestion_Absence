<?php
session_start();
require_once "../../models/XmlManager.php";

if (!isset($_SESSION['user']) || $_SESSION['user']['role'] !== 'teacher') {
    header("Location: ../../login.php");
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $seanceId = $_POST['seance_id'];
    $absentStudents = $_POST['absent_students'] ?? []; // tableau des IDs cochés

    $absencesXml = new XmlManager(__DIR__ . "/../../data/absences.xml");
    $absences = $absencesXml->getAll();

    // Supprimer les anciennes absences pour cette séance
    foreach ($absences->absence as $absence) {
        if ((string)$absence->seanceId === $seanceId) {
            $dom = dom_import_simplexml($absence);
            $dom->parentNode->removeChild($dom);
        }
    }

    // Ajouter les nouvelles absences
    foreach ($absentStudents as $studentId) {
        $absence = $absences->addChild('absence');
        $absence->addAttribute('id', uniqid('a'));
        $absence->addChild('studentId', $studentId);
        $absence->addChild('seanceId', $seanceId);
        $absence->addChild('date', date('Y-m-d'));
        $absence->addChild('hours', date('H:i'));
        $absence->addChild('teacherId', $_SESSION['user']['id']);
    }

    $absencesXml->save();
}

header("Location: dashboard.php");
exit;
