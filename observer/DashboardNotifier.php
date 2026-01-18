<?php
// observers/DashboardNotifier.php
require_once 'ObserverInterface.php';

class DashboardNotifier implements ObserverInterface {
    private $name;
    private $basePath;
    
    public function __construct($name = "DashboardNotifier", $basePath = null) {
        $this->name = $name;
        // Utiliser le même système de chemin que AbsenceManager
        $this->basePath = $basePath ?: $this->determineBasePath();
    }
    
    private function determineBasePath() {
        $possiblePaths = [
            __DIR__ . '/../data/',
            dirname(__DIR__) . '/data/',
            realpath(__DIR__ . '/../../data/'),
            'C:/xampp1/htdocs/Gestion_Absence/data/'
        ];
        
        foreach ($possiblePaths as $path) {
            if (is_dir($path)) {
                return $path;
            }
        }
        
        return dirname(__DIR__) . '/data/';
    }
    
    public function update($absenceData) {
        // Utiliser le chemin de base des données d'absence si fourni
        if (isset($absenceData['base_path'])) {
            $this->basePath = $absenceData['base_path'];
        }
        
        // Sauvegarder la notification pour l'étudiant
        $saveResult = $this->saveNotification($absenceData);
        
        // Mettre à jour le compteur d'absences
        $updateResult = $this->updateStudentAbsenceCount($absenceData['student_id']);
        
        return [
            'success' => $saveResult && $updateResult,
            'message' => 'Notification enregistrée dans le dashboard étudiant',
            'type' => 'dashboard',
            'student_id' => $absenceData['student_id'],
            'save_result' => $saveResult,
            'update_result' => $updateResult
        ];
    }
    
    /**
     * Sauvegarder la notification
     */
    private function saveNotification($data) {
        $notificationsFile = $this->basePath . 'student_notifications.xml';
        
        // Créer le répertoire s'il n'existe pas
        $dataDir = dirname($notificationsFile);
        if (!is_dir($dataDir)) {
            mkdir($dataDir, 0755, true);
        }
        
        // Charger ou créer le fichier de notifications
        if (file_exists($notificationsFile)) {
            $xml = simplexml_load_file($notificationsFile);
            if ($xml === false) {
                $xml = new SimpleXMLElement('<?xml version="1.0" encoding="UTF-8"?><notifications></notifications>');
            }
        } else {
            $xml = new SimpleXMLElement('<?xml version="1.0" encoding="UTF-8"?><notifications></notifications>');
        }
        
        // Ajouter une nouvelle notification
        $notification = $xml->addChild('notification');
        $notification->addChild('id', 'NOTIF' . uniqid());
        $notification->addChild('student_id', $data['student_id']);
        $notification->addChild('student_name', $data['student_name']);
        $notification->addChild('seance_id', $data['seance_id']);
        $notification->addChild('seance_module', $data['seance_module']);
        $notification->addChild('seance_datetime', $data['seance_datetime']);
        $notification->addChild('teacher_id', $data['teacher_id'] ?? '');
        $notification->addChild('type', 'absence');
        
        // Message
        $formattedDate = date('d/m/Y H:i', strtotime($data['seance_datetime']));
        $message = "Vous avez été marqué absent pour la séance de " . 
                  $data['seance_module'] . " du " . $formattedDate;
        
        $notification->addChild('message', $message);
        $notification->addChild('created_at', date('Y-m-d H:i:s'));
        $notification->addChild('date', date('Y-m-d H:i:s'));
        $notification->addChild('read', 'false');
        $notification->addChild('important', 'true');
        
        // Sauvegarder
        return $xml->asXML($notificationsFile);
    }
    
    /**
     * Mettre à jour le compteur d'absences
     */
    private function updateStudentAbsenceCount($studentId) {
        $studentsFile = $this->basePath . 'students.xml';
        
        if (!file_exists($studentsFile)) {
            return false;
        }
        
        $xml = simplexml_load_file($studentsFile);
        if ($xml === false) {
            return false;
        }
        
        // Trouver l'étudiant
        foreach ($xml->student as $student) {
            if ((string)$student['id'] === $studentId) {
                // Mettre à jour le compteur
                if (!isset($student->absence_count)) {
                    $student->addChild('absence_count', '1');
                } else {
                    $current = (int)$student->absence_count;
                    $student->absence_count = (string)($current + 1);
                }
                
                // Ajouter la date
                if (!isset($student->last_absence)) {
                    $student->addChild('last_absence', date('Y-m-d H:i:s'));
                } else {
                    $student->last_absence = date('Y-m-d H:i:s');
                }
                
                // Sauvegarder
                return $xml->asXML($studentsFile);
            }
        }
        
        return false;
    }
    
    // ... (le reste des méthodes reste inchangé)
    
    /**
     * Définir le chemin de base manuellement
     */
    public function setBasePath($path) {
        $this->basePath = rtrim($path, '/') . '/';
    }
}
?>