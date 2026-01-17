<?php
// observers/AbsenceManager.php
require_once 'Subject.php';
require_once 'ObserverInterface.php';

class AbsenceManager implements Subject {
    private $observers = [];
    private $absenceData;
    private $notificationResults = [];
    
    public function __construct() {
        $this->observers = [];
        $this->notificationResults = [];
    }
    
    public function attach(ObserverInterface $observer) {
        $this->observers[] = $observer;
        error_log("AbsenceManager: Observateur attaché - " . get_class($observer));
    }
    
    public function detach(ObserverInterface $observer) {
        $key = array_search($observer, $this->observers, true);
        if ($key !== false) {
            unset($this->observers[$key]);
            $this->observers = array_values($this->observers);
        }
    }
    
    public function notify() {
        $this->notificationResults = [];
        
        foreach ($this->observers as $observer) {
            try {
                $result = $observer->update($this->absenceData);
                $this->notificationResults[] = [
                    'observer' => get_class($observer),
                    'result' => $result,
                    'success' => $result['success'] ?? false
                ];
                error_log("AbsenceManager: " . get_class($observer) . " notifié avec succès");
            } catch (Exception $e) {
                error_log("AbsenceManager: Erreur avec " . get_class($observer) . " - " . $e->getMessage());
                $this->notificationResults[] = [
                    'observer' => get_class($observer),
                    'error' => $e->getMessage(),
                    'success' => false
                ];
            }
        }
        
        return $this->notificationResults;
    }
    
    /**
     * Marquer une absence et notifier
     */
    public function markAbsence($studentId, $seanceId, $teacherId = null, $module = null, $date = null) {
        // Charger les données de l'étudiant
        $studentsFile = '../data/students.xml';
        $students = simplexml_load_file($studentsFile);
        
        $studentData = [];
        foreach ($students->student as $student) {
            if ((string)$student['id'] === $studentId) {
                $studentData = [
                    'id' => $studentId,
                    'name' => (string)$student->name,
                    'email' => (string)$student->email,
                    'class' => (string)$student->class
                ];
                break;
            }
        }
        
        // Charger les données de la séance
        $seancesFile = '../data/seances.xml';
        $seances = simplexml_load_file($seancesFile);
        
        $seanceData = [];
        foreach ($seances->seance as $seance) {
            if ((string)$seance['id'] === $seanceId) {
                $seanceData = [
                    'id' => $seanceId,
                    'module' => (string)$seance->module,
                    'datetime' => (string)$seance->datetime,
                    'class_id' => (string)$seance->class_id
                ];
                break;
            }
        }
        
        // Préparer les données d'absence
        $this->absenceData = [
            'student_id' => $studentId,
            'student_name' => $studentData['name'] ?? 'Étudiant',
            'student_email' => $studentData['email'] ?? '',
            'seance_id' => $seanceId,
            'seance_module' => $module ?? $seanceData['module'] ?? 'Non spécifié',
            'seance_datetime' => $date ?? $seanceData['datetime'] ?? date('Y-m-d H:i:s'),
            'teacher_id' => $teacherId,
            'timestamp' => date('Y-m-d H:i:s'),
            'type' => 'absence',
            'action' => 'marked'
        ];
        
        // Notifier tous les observateurs
        return $this->notify();
    }
    
    /**
     * Récupérer les résultats des notifications
     */
    public function getNotificationResults() {
        return $this->notificationResults;
    }
}
?>