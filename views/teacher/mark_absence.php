<?php
session_start();

require_once "../../observer/AbsenceManager.php";
require_once "../../observer/StudentNotifier.php";
require_once "../../models/XmlManager.php";

// Multilang
$langFile = "../../lang/" . ($_SESSION['lang'] ?? "fr") . ".php";
if (file_exists($langFile)) {
    $langs = include $langFile;
} else {
    $langs = [];
}

// Vérification rôle
if (!isset($_SESSION['user']) || $_SESSION['user']['role'] !== 'teacher') {
    header("Location: ../../login.php");
    exit;
}

$absenceManager = new AbsenceManager();
$studentNotifier = new StudentNotifier();
$absenceManager->attach($studentNotifier);

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $seanceId = $_POST['seance_id'] ?? '';
    $classId = $_POST['class_id'] ?? '';
    $teacherId = $_SESSION['user']['id'];
    $absentStudents = $_POST['absent_students'] ?? [];
    
    // Charger le fichier des séances pour récupérer les infos
    $seancesXml = new XmlManager("../../data/seances.xml");
    $seances = $seancesXml->getAll();
    
    // Trouver la séance pour récupérer le module
    $module = "";
    foreach ($seances->seance as $seance) {
        if ((string)$seance['id'] === $seanceId) {
            $module = (string)$seance->module;
            break;
        }
    }
    
    // Charger le fichier des absences
    $absencesXml = new XmlManager("../../data/absences.xml");
    $absences = $absencesXml->getAll();
    
    foreach ($absentStudents as $studentId) {
        // Vérifier si l'absence existe déjà
        $alreadyExists = false;
        foreach ($absences->absence as $existingAbsence) {
            if ((string)$existingAbsence->studentId === $studentId && 
                ((string)$existingAbsence->seanceId === $seanceId || 
                 (string)$existingAbsence->seance_id === $seanceId)) {
                $alreadyExists = true;
                break;
            }
        }
        
        if (!$alreadyExists) {
            // Message multilingue
            $message = sprintf(
                $langs["notifications"]["absence"] ?? "Absence enregistrée pour la séance %s",
                $seanceId
            );

            // 1. Marquer l'absence dans le système Observer
            $absenceManager->markAbsence($studentId, $seanceId);
            
            // 2. Ajouter l'absence au XML avec TOUTES les informations
            $absence = $absences->addChild("absence");
            $absence->addAttribute("id", uniqid("a"));
            $absence->addChild("studentId", $studentId);
            $absence->addChild("seanceId", $seanceId);
            $absence->addChild("teacherId", $teacherId);
            $absence->addChild("module", $module); // IMPORTANT: Ajouter le module
            $absence->addChild("date", date("Y-m-d"));
            $absence->addChild("hours", date("H:i"));
            $absence->addChild("status", "Absent");
        }
    }
    
    // Sauvegarder le fichier XML
    $absencesXml->save();
}

header("Location: dashboard.php");
exit;
?>