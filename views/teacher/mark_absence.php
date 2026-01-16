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

    // Charger les fichiers XML nécessaires
    $absencesXml = new XmlManager(__DIR__ . "/../../data/absences.xml");
    $absences = $absencesXml->getAll();
    
    // AJOUT: Charger les séances pour récupérer le module
    $seancesXml = new XmlManager(__DIR__ . "/../../data/seances.xml");
    $seances = $seancesXml->getAll();
    
    // AJOUT: Charger les étudiants pour récupérer leurs infos
    $studentsXml = new XmlManager(__DIR__ . "/../../data/students.xml");
    $students = $studentsXml->getAll();

    // Supprimer les anciennes absences pour cette séance
    foreach ($absences->absence as $absence) {
        if ((string)$absence->seanceId === $seanceId) {
            $dom = dom_import_simplexml($absence);
            $dom->parentNode->removeChild($dom);
        }
    }

    // Récupérer le module de la séance
    $module = "";
    foreach ($seances->seance as $seance) {
        if ((string)$seance['id'] === $seanceId) {
            $module = (string)$seance->module;
            break;
        }
    }
    
    // Si le module n'est pas trouvé dans les séances, utiliser celui de l'enseignant
    if (empty($module)) {
        // Charger les enseignants pour récupérer le module de l'enseignant
        $teachersXml = new XmlManager(__DIR__ . "/../../data/teachers.xml");
        $teachers = $teachersXml->getAll();
        
        foreach ($teachers->teacher as $teacher) {
            if ((string)$teacher['id'] === $_SESSION['user']['id']) {
                $module = (string)$teacher->module;
                break;
            }
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
        
        // AJOUT CRUCIAL: Ajouter le module à l'absence
        if (!empty($module)) {
            $absence->addChild('module', $module);
        }
    }

    $absencesXml->save();
}

header("Location: dashboard.php");
exit;