<?php
// controllers/mark_absence.php
session_start();

require_once "../observer/AbsenceManager.php";
require_once "../observer/StudentNotifier.php";
require_once "../observer/DashboardNotifier.php";
require_once "../models/XmlManager.php";

// Vérification rôle
if (!isset($_SESSION['user']) || $_SESSION['user']['role'] !== 'teacher') {
    header("Location: ../login.php");
    exit;
}

// Définir le chemin de base ABSOLU
$basePath = dirname(__DIR__) . '/data/';

$absenceManager = new AbsenceManager($basePath);

// Attacher les deux observateurs avec le même chemin
$studentNotifier = new StudentNotifier("StudentNotifier", $basePath);
$dashboardNotifier = new DashboardNotifier("DashboardNotifier", $basePath);

$absenceManager->attach($studentNotifier);
$absenceManager->attach($dashboardNotifier);



if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $seanceId = $_POST['seance_id'] ?? '';
    $classId = $_POST['class_id'] ?? '';
    $teacherId = $_SESSION['user']['id'];
    $absentStudents = $_POST['absent_students'] ?? [];
    
    // Charger les fichiers XML
    $seancesXml = new XmlManager("../data/seances.xml");
    $absencesXml = new XmlManager("../data/absences.xml");
    
    $seances = $seancesXml->getAll();
    $absences = $absencesXml->getAll();
    
    // Trouver les infos de la séance
    $module = "";
    foreach ($seances->seance as $seance) {
        if ((string)$seance['id'] === $seanceId) {
            $module = (string)$seance->module;
            break;
        }
    }
    
    $results = [];
    
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
            // Ajouter l'absence au XML
            $absence = $absences->addChild("absence");
            $absence->addAttribute("id", uniqid("a"));
            $absence->addChild("studentId", $studentId);
            $absence->addChild("seanceId", $seanceId);
            $absence->addChild("teacherId", $teacherId);
            $absence->addChild("module", $module);
            $absence->addChild("date", date("Y-m-d"));
            $absence->addChild("hours", date("H:i"));
            $absence->addChild("status", "Absent");
            $absence->addChild("notified", "true");
            $absence->addChild("notification_date", date("Y-m-d H:i:s"));
            
            // NOTIFIER via l'AbsenceManager
            try {
                $notificationResult = $absenceManager->markAbsence(
                    $studentId, 
                    $seanceId, 
                    $teacherId, 
                    $module, 
                    date("Y-m-d H:i:s")
                );
                
                $results[] = [
                    'student_id' => $studentId,
                    'success' => true,
                    'notifications' => $notificationResult
                ];
                
            } catch (Exception $e) {
                $results[] = [
                    'student_id' => $studentId,
                    'success' => false,
                    'error' => $e->getMessage()
                ];
            }
        }
    }
    
    // Sauvegarder le fichier XML
    $absencesXml->save();
    
    // Stocker les résultats pour affichage
    $_SESSION['absence_results'] = $results;
    $_SESSION['success_message'] = count($absentStudents) . " absence(s) enregistrée(s) et notifiée(s)";
}

header("Location: ../views/teacher/dashboard.php");
exit;
?>