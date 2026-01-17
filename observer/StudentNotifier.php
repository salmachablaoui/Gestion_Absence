<?php
// observers/StudentNotifier.php
require_once 'ObserverInterface.php';

class StudentNotifier implements ObserverInterface {
    private $name;
    
    public function __construct($name = "StudentNotifier") {
        $this->name = $name;
    }
    
    public function update($absenceData) {
        $this->sendEmailNotification($absenceData);
        $this->logNotification($absenceData);
        
        return [
            'success' => true,
            'message' => 'Notification envoyée à l\'étudiant',
            'type' => 'student'
        ];
    }
    
    private function sendEmailNotification($data) {
        $studentEmail = $data['student_email'] ?? '';
        $studentName = $data['student_name'] ?? 'Étudiant';
        $seanceModule = $data['seance_module'] ?? 'Séance';
        $seanceDatetime = $data['seance_datetime'] ?? '';
        
        if (empty($studentEmail)) {
            error_log("StudentNotifier: Email étudiant non fourni");
            return false;
        }
        
        $subject = "📋 Notification d'absence - " . $seanceModule;
        
        $message = "
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset='UTF-8'>
            <style>
                body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
                .container { max-width: 600px; margin: 0 auto; padding: 20px; }
                .header { background-color: #f8f9fa; padding: 20px; text-align: center; border-radius: 5px; }
                .content { padding: 20px; }
                .warning { background-color: #fff3cd; border: 1px solid #ffeaa7; padding: 15px; border-radius: 4px; margin: 15px 0; }
                .footer { margin-top: 20px; padding-top: 20px; border-top: 1px solid #dee2e6; color: #6c757d; font-size: 0.9em; }
            </style>
        </head>
        <body>
            <div class='container'>
                <div class='header'>
                    <h2>📋 Notification d'absence</h2>
                </div>
                <div class='content'>
                    <p>Bonjour <strong>$studentName</strong>,</p>
                    
                    <div class='warning'>
                        <p>⚠️ <strong>Vous avez été marqué(e) absent(e)</strong> à la séance suivante :</p>
                    </div>
                    
                    <h3>Détails :</h3>
                    <ul>
                        <li><strong>Module :</strong> $seanceModule</li>
                        <li><strong>Date :</strong> " . date('d/m/Y H:i', strtotime($seanceDatetime)) . "</li>
                    </ul>
                    
                    <p>Si vous pensez qu'il s'agit d'une erreur, veuillez contacter votre enseignant.</p>
                    
                    <p>Cordialement,<br><strong>Système de Gestion des Absences</strong></p>
                </div>
                <div class='footer'>
                    <p>Cet email a été envoyé automatiquement. Merci de ne pas y répondre.</p>
                </div>
            </div>
        </body>
        </html>";
        
        // Headers pour email HTML
        $headers = "MIME-Version: 1.0" . "\r\n";
        $headers .= "Content-type:text/html;charset=UTF-8" . "\r\n";
        $headers .= "From: Gestion Absence <noreply@votresite.com>" . "\r\n";
        $headers .= "Reply-To: administration@votresite.com" . "\r\n";
        $headers .= "X-Mailer: PHP/" . phpversion();
        
        // Envoyer l'email
        $sent = mail($studentEmail, $subject, $message, $headers);
        
        if ($sent) {
            error_log("StudentNotifier: Email envoyé à $studentEmail");
        } else {
            error_log("StudentNotifier: Échec d'envoi à $studentEmail");
        }
        
        return $sent;
    }
    
    private function logNotification($data) {
        $logFile = '../logs/notifications.log';
        $logEntry = date('Y-m-d H:i:s') . " | STUDENT | " . 
                   "Étudiant: " . ($data['student_name'] ?? 'Inconnu') . " | " .
                   "Email: " . ($data['student_email'] ?? 'Inconnu') . " | " .
                   "Séance: " . ($data['seance_module'] ?? 'Inconnue') . "\n";
        
        file_put_contents($logFile, $logEntry, FILE_APPEND);
    }
    
    public function getName() {
        return $this->name;
    }
}
?>