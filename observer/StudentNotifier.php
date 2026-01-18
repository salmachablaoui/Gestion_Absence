<?php
// observers/StudentNotifier.php
require_once 'ObserverInterface.php';

class StudentNotifier implements ObserverInterface {
    private $name;
    private $basePath;
    
    public function __construct($name = "StudentNotifier", $basePath = null) {
        $this->name = $name;
        // Déterminer le chemin de base
        $this->basePath = $basePath ?: $this->determineBasePath();
    }
    
    private function determineBasePath() {
        // Essayer différents chemins
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
        // Log de débogage
        error_log("StudentNotifier: Début update() pour étudiant " . $absenceData['student_id']);
        
        // Préparer le message
        $message = $this->prepareNotificationMessage($absenceData);
        
        // Obtenir l'email de l'étudiant
        $studentEmail = $this->getStudentEmail($absenceData['student_id']);
        
        // Si email trouvé, envoyer notification
        $emailSent = false;
        if (!empty($studentEmail)) {
            $emailSent = $this->sendEmailNotification($studentEmail, $message);
        } else {
            error_log("StudentNotifier: Email non trouvé pour étudiant " . $absenceData['student_id']);
        }
        
        // Toujours logguer la notification
        $this->logNotification($absenceData['student_id'], $message, $studentEmail, $emailSent);
        
        return [
            'success' => true,
            'message' => 'Notification traitée pour l\'étudiant',
            'type' => 'student',
            'student_id' => $absenceData['student_id'],
            'email_sent' => $emailSent,
            'student_email' => $studentEmail
        ];
    }
    
    /**
     * Préparer le message de notification
     */
    private function prepareNotificationMessage($data) {
        $formattedDate = date('d/m/Y H:i', strtotime($data['seance_datetime']));
        
        $message = "Notification d'absence\n";
        $message .= "=====================\n\n";
        $message .= "Cher(e) " . $data['student_name'] . ",\n\n";
        $message .= "Vous avez été marqué(e) absent(e) pour la séance suivante :\n\n";
        $message .= "Module : " . $data['seance_module'] . "\n";
        $message .= "Date et heure : " . $formattedDate . "\n";
        $message .= "Séance ID : " . $data['seance_id'] . "\n";
        
        if (!empty($data['teacher_id'])) {
            $message .= "Enseignant : " . $data['teacher_id'] . "\n";
        }
        
        $message .= "\nCette absence a été enregistrée le : " . date('d/m/Y à H:i:s') . "\n";
        $message .= "\nCordialement,\nSystème de Gestion des Absences";
        
        return $message;
    }
    
    /**
     * Récupérer l'email de l'étudiant
     */
    private function getStudentEmail($studentId) {
        $studentsFile = $this->basePath . 'students.xml';
        
        if (!file_exists($studentsFile)) {
            error_log("StudentNotifier: Fichier students.xml introuvable: " . $studentsFile);
            return null;
        }
        
        $xml = simplexml_load_file($studentsFile);
        if ($xml === false) {
            error_log("StudentNotifier: Impossible de charger students.xml");
            return null;
        }
        
        foreach ($xml->student as $student) {
            if ((string)$student['id'] === $studentId) {
                return (string)$student->email;
            }
        }
        
        return null;
    }
    
    /**
     * Envoyer notification par email (version simplifiée pour XAMPP)
     */
    private function sendEmailNotification($studentEmail, $message) {
        // Pour XAMPP, on va simuler l'envoi et logguer
        // En production, vous pourrez décommenter le vrai envoi
        
        $subject = "Notification d'absence - Système de Gestion";
        
        // Option 1: Simulation (recommandée pour développement)
        $this->logEmailSimulation($studentEmail, $subject, $message);
        return true;
        
        // Option 2: Vrai envoi email (à utiliser quand SMTP est configuré)
        /*
        // Configuration SMTP pour XAMPP
        ini_set('SMTP', 'localhost');
        ini_set('smtp_port', 25);
        ini_set('sendmail_from', 'noreply@gesabs.com');
        
        $headers = "From: noreply@gesabs.com\r\n";
        $headers .= "Content-Type: text/plain; charset=utf-8\r\n";
        
        return mail($studentEmail, $subject, $message, $headers);
        */
    }
    
    /**
     * Simuler l'envoi d'email et logguer
     */
    private function logEmailSimulation($to, $subject, $message) {
        $logDir = $this->basePath . '../logs/';
        
        // Créer le dossier logs s'il n'existe pas
        if (!is_dir($logDir)) {
            mkdir($logDir, 0755, true);
        }
        
        $logFile = $logDir . 'email_simulation.log';
        
        $logEntry = "=" . str_repeat("=", 70) . "\n";
        $logEntry .= "DATE: " . date('Y-m-d H:i:s') . "\n";
        $logEntry .= "TO: " . $to . "\n";
        $logEntry .= "SUBJECT: " . $subject . "\n";
        $logEntry .= "MESSAGE:\n" . $message . "\n";
        $logEntry .= "=" . str_repeat("=", 70) . "\n\n";
        
        file_put_contents($logFile, $logEntry, FILE_APPEND);
        
        error_log("StudentNotifier: Email simulé pour " . $to . " - voir " . $logFile);
    }
    
    /**
     * Logguer la notification (alternative au fichier log)
     */
    private function logNotification($studentId, $message, $studentEmail, $emailSent) {
        // Créer un fichier de log dans le dossier data
        $logFile = $this->basePath . 'student_notifications_log.txt';
        
        $logEntry = date('Y-m-d H:i:s') . " | ";
        $logEntry .= "Student: " . $studentId . " | ";
        $logEntry .= "Email: " . ($studentEmail ?: 'Non trouvé') . " | ";
        $logEntry .= "Email envoyé: " . ($emailSent ? 'OUI' : 'NON') . " | ";
        $logEntry .= "Message: " . substr(str_replace(["\n", "\r"], ' ', $message), 0, 100) . "...\n";
        
        file_put_contents($logFile, $logEntry, FILE_APPEND);
        
        // Aussi log dans le journal système PHP
        error_log("Notification pour étudiant " . $studentId . " - Email: " . ($emailSent ? "simulé" : "non envoyé"));
    }
    
    /**
     * Récupérer les notifications d'un étudiant (pour compatibilité)
     */
    public static function getNotificationsForStudent($studentId, $basePath = null) {
        $notifier = new self("TempNotifier", $basePath);
        $notifFile = $notifier->basePath . 'student_notifications.xml';
        
        if (!file_exists($notifFile)) {
            return [];
        }
        
        $xml = simplexml_load_file($notifFile);
        $notifications = [];
        
        foreach ($xml->notification as $notification) {
            if ((string)$notification->student_id === $studentId) {
                $notifications[] = [
                    'id' => (string)($notification->id ?? ''),
                    'student_id' => (string)$notification->student_id,
                    'message' => (string)$notification->message,
                    'date' => (string)$notification->date,
                    'module' => (string)($notification->seance_module ?? ''),
                    'seance_id' => (string)($notification->seance_id ?? '')
                ];
            }
        }
        
        return $notifications;
    }
    
    /**
     * Méthode pour vider les logs (utile pour le débogage)
     */
    public function clearLogs() {
        $logDir = $this->basePath . '../logs/';
        $logFile = $this->basePath . 'student_notifications_log.txt';
        
        if (file_exists($logFile)) {
            file_put_contents($logFile, '');
        }
        
        if (is_dir($logDir)) {
            $emailLog = $logDir . 'email_simulation.log';
            if (file_exists($emailLog)) {
                file_put_contents($emailLog, '');
            }
        }
        
        return true;
    }
    
    /**
     * Récupérer le nom du notifier
     */
    public function getName() {
        return $this->name;
    }
    
    /**
     * Définir le chemin de base manuellement
     */
    public function setBasePath($path) {
        $this->basePath = rtrim($path, '/') . '/';
        return $this;
    }
    
    /**
     * Récupérer le chemin de base
     */
    public function getBasePath() {
        return $this->basePath;
    }
}
?>