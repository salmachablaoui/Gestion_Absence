<?php
// views/teacher/mark_absence.php
session_start();

// Déterminer le chemin de base ABSOLU
$basePath = dirname(__DIR__, 2) . '/'; // Remonte 2 niveaux: views/teacher -> Gestion_Absence/

// Inclure les fichiers nécessaires
require_once $basePath . 'observer/AbsenceManager.php';
require_once $basePath . 'observer/StudentNotifier.php';
require_once $basePath . 'observer/DashboardNotifier.php';
require_once $basePath . 'models/XmlManager.php';

// Vérification rôle
if (!isset($_SESSION['user']) || $_SESSION['user']['role'] !== 'teacher') {
    header("Location: " . $basePath . "login.php");
    exit;
}

// Définir le chemin des données
$dataPath = $basePath . 'data/';

// Initialiser les composants
$absenceManager = new AbsenceManager($dataPath);
$studentNotifier = new StudentNotifier("StudentNotifier", $dataPath);
$dashboardNotifier = new DashboardNotifier("DashboardNotifier", $dataPath);

// Attacher les observateurs
$absenceManager->attach($studentNotifier);
$absenceManager->attach($dashboardNotifier);

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $seanceId = $_POST['seance_id'] ?? '';
    $classId = $_POST['class_id'] ?? '';
    $teacherId = $_SESSION['user']['id'];
    $absentStudents = $_POST['absent_students'] ?? [];
    
    if (empty($seanceId) || empty($classId) || empty($absentStudents)) {
        $_SESSION['error_message'] = "Données manquantes!";
        header("Location: dashboard.php");
        exit;
    }
    
    // Charger les fichiers XML
    $seancesXml = new XmlManager($dataPath . 'seances.xml');
    $absencesXml = new XmlManager($dataPath . 'absences.xml');
    
    $seances = $seancesXml->getAll();
    $absences = $absencesXml->getAll();
    
    // Trouver le module réel de la séance
    $module = '';
    foreach ($seances->seance as $seance) {
        if ((string)$seance['id'] === $seanceId) {
            $module = (string)$seance->module ?? 'Module par défaut';
            break;
        }
    }
    
    if (empty($module)) {
        $_SESSION['error_message'] = "Séance non trouvée!";
        header("Location: dashboard.php");
        exit;
    }
    
    $results = [];
    $successCount = 0;
    
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
        
        if ($alreadyExists) {
            $results[] = [
                'student_id' => $studentId,
                'success' => false,
                'error' => 'Absence déjà enregistrée'
            ];
            continue;
        }
        
        // Ajouter l'absence au XML avec le module réel
        $absence = $absences->addChild("absence");
        $absence->addAttribute("id", uniqid("a"));
        $absence->addChild("studentId", $studentId);
        $absence->addChild("seanceId", $seanceId);
        $absence->addChild("teacherId", $teacherId);
        $absence->addChild("module", $module); // ← module réel
        $absence->addChild("date", date("Y-m-d"));
        $absence->addChild("hours", date("H:i"));
        $absence->addChild("status", "Absent");
        $absence->addChild("notified", "true");
        $absence->addChild("notification_date", date("Y-m-d H:i:s"));
        
        // NOTIFIER via l'AbsenceManager et transmettre le module réel
        try {
            $notificationResult = $absenceManager->markAbsence(
                $studentId, 
                $seanceId, 
                $teacherId, 
                $module, // ← module réel
                date("Y-m-d H:i:s")
            );
            
            $results[] = [
                'student_id' => $studentId,
                'success' => true,
                'notifications' => $notificationResult
            ];
            
            $successCount++;
            
        } catch (Exception $e) {
            $results[] = [
                'student_id' => $studentId,
                'success' => false,
                'error' => $e->getMessage()
            ];
        }
    }
    
    // Sauvegarder le fichier XML
    $absencesXml->save();
    
    // Créer le fichier notifications si inexistant
    $notifFile = $dataPath . 'student_notifications.xml';
    if (!file_exists($notifFile)) {
        $xml = new SimpleXMLElement('<?xml version="1.0" encoding="UTF-8"?><notifications></notifications>');
        $xml->asXML($notifFile);
    }
    
    // Stocker les résultats
    $_SESSION['absence_results'] = $results;
    $_SESSION['success_message'] = "$successCount absence(s) enregistrée(s) avec succès!";
}

header("Location: dashboard.php");
exit;
?>
