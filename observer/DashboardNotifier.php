<?php
// observers/DashboardNotifier.php
require_once 'ObserverInterface.php';

class DashboardNotifier implements ObserverInterface {
    private $name;
    private $notificationsFile;
    
    public function __construct($name = "DashboardNotifier") {
        $this->name = $name;
        $this->notificationsFile = '../data/student_notifications.xml';
    }
    
    public function update($absenceData) {
        // Sauvegarder la notification pour l'étudiant
        $this->saveNotification($absenceData);
        
        // Mettre à jour le compteur d'absences dans students.xml
        $this->updateStudentAbsenceCount($absenceData['student_id']);
        
        return [
            'success' => true,
            'message' => 'Notification enregistrée dans le dashboard étudiant',
            'type' => 'dashboard',
            'student_id' => $absenceData['student_id']
        ];
    }
    
    /**
     * Sauvegarder la notification pour l'affichage dans le dashboard
     */
    private function saveNotification($data) {
        // Créer le répertoire data s'il n'existe pas
        $dataDir = dirname($this->notificationsFile);
        if (!is_dir($dataDir)) {
            mkdir($dataDir, 0755, true);
        }
        
        // Charger ou créer le fichier de notifications
        if (file_exists($this->notificationsFile)) {
            $xml = simplexml_load_file($this->notificationsFile);
        } else {
            $xml = new SimpleXMLElement('<?xml version="1.0" encoding="UTF-8"?><notifications></notifications>');
        }
        
        // Vérifier si une notification existe déjà pour cette séance/étudiant
        $alreadyExists = false;
        foreach ($xml->notification as $notification) {
            if ((string)$notification->student_id === $data['student_id'] && 
                (string)$notification->seance_id === $data['seance_id']) {
                $alreadyExists = true;
                break;
            }
        }
        
        if (!$alreadyExists) {
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
            $notification->addChild('message', 'Vous avez été marqué absent pour la séance de ' . $data['seance_module']);
            $notification->addChild('created_at', date('Y-m-d H:i:s'));
            $notification->addChild('read', 'false');
            $notification->addChild('important', 'true');
            
            // Sauvegarder
            $xml->asXML($this->notificationsFile);
            
            error_log("DashboardNotifier: Notification enregistrée pour " . $data['student_name']);
        }
        
        return true;
    }
    
    /**
     * Mettre à jour le compteur d'absences de l'étudiant
     */
    private function updateStudentAbsenceCount($studentId) {
        $studentsFile = '../data/students.xml';
        
        if (!file_exists($studentsFile)) {
            return false;
        }
        
        $xml = simplexml_load_file($studentsFile);
        
        // Trouver l'étudiant
        foreach ($xml->student as $student) {
            if ((string)$student['id'] === $studentId) {
                // Mettre à jour le compteur d'absences
                if (!isset($student->absence_count)) {
                    $student->addChild('absence_count', '1');
                } else {
                    $current = (int)$student->absence_count;
                    $student->absence_count = (string)($current + 1);
                }
                
                // Ajouter la date de dernière absence
                if (!isset($student->last_absence)) {
                    $student->addChild('last_absence', date('Y-m-d H:i:s'));
                } else {
                    $student->last_absence = date('Y-m-d H:i:s');
                }
                
                // Sauvegarder
                $xml->asXML($studentsFile);
                
                error_log("DashboardNotifier: Compteur mis à jour pour étudiant " . $studentId);
                return true;
            }
        }
        
        return false;
    }
    
    public function getName() {
        return $this->name;
    }
    
    /**
     * Récupérer les notifications non lues d'un étudiant
     */
    public static function getUnreadNotifications($studentId) {
        $notificationsFile = '../data/student_notifications.xml';
        
        if (!file_exists($notificationsFile)) {
            return [];
        }
        
        $xml = simplexml_load_file($notificationsFile);
        $notifications = [];
        
        foreach ($xml->notification as $notification) {
            if ((string)$notification->student_id === $studentId && 
                (string)$notification->read === 'false') {
                $notifications[] = [
                    'id' => (string)$notification->id,
                    'message' => (string)$notification->message,
                    'module' => (string)$notification->seance_module,
                    'datetime' => (string)$notification->seance_datetime,
                    'created_at' => (string)$notification->created_at,
                    'important' => (string)$notification->important === 'true'
                ];
            }
        }
        
        return $notifications;
    }
    
    /**
     * Marquer une notification comme lue
     */
    public static function markAsRead($notificationId) {
        $notificationsFile = '../data/student_notifications.xml';
        
        if (!file_exists($notificationsFile)) {
            return false;
        }
        
        $xml = simplexml_load_file($notificationsFile);
        
        foreach ($xml->notification as $notification) {
            if ((string)$notification->id === $notificationId) {
                $notification->read = 'true';
                $xml->asXML($notificationsFile);
                return true;
            }
        }
        
        return false;
    }
}
?>