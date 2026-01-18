<?php
// observers/AbsenceManager.php
require_once 'Subject.php';
require_once 'ObserverInterface.php';

class AbsenceManager implements Subject {
    private $observers = [];
    private $absenceData;
    private $notificationResults = [];
    private $basePath;
    
    public function __construct($basePath = null) {
        $this->observers = [];
        $this->notificationResults = [];
        // Déterminer le chemin de base automatiquement
        $this->basePath = $basePath ?: $this->determineBasePath();
    }
    
    private function determineBasePath() {
        // Essayer différentes méthodes pour trouver le bon chemin
        $possiblePaths = [
            __DIR__ . '/../data/',  // depuis observers/
            dirname(__DIR__) . '/data/',  // depuis Gestion_Absence/
            realpath(__DIR__ . '/../../data/'),
            'C:/xampp1/htdocs/Gestion_Absence/data/'
        ];
        
        foreach ($possiblePaths as $path) {
            if (file_exists($path . 'students.xml')) {
                return $path;
            }
        }
        
        // Si aucun chemin ne fonctionne, utiliser le répertoire courant
        return dirname(__DIR__) . '/data/';
    }
    
    public function attach(ObserverInterface $observer) {
        $this->observers[] = $observer;
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
        
        if (empty($this->absenceData)) {
            return [];
        }
        
        foreach ($this->observers as $observer) {
            try {
                $result = $observer->update($this->absenceData);
                $this->notificationResults[] = [
                    'observer' => get_class($observer),
                    'result' => $result,
                    'success' => $result['success'] ?? false
                ];
            } catch (Exception $e) {
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
        // Vérifier les paramètres essentiels
        if (empty($studentId) || empty($seanceId)) {
            throw new Exception("Paramètres manquants: studentId ou seanceId");
        }
        
        // Utiliser le chemin de base déterminé
        $studentsFile = $this->basePath . 'students.xml';
        $seancesFile = $this->basePath . 'seances.xml';
        
        // Log pour debug
        error_log("Chemin students.xml: " . $studentsFile);
        error_log("Fichier existe: " . (file_exists($studentsFile) ? 'OUI' : 'NON'));
        
        if (!file_exists($studentsFile)) {
            throw new Exception("Fichier students.xml introuvable à: " . $studentsFile);
        }
        
        // Charger les données de l'étudiant
        $students = simplexml_load_file($studentsFile);
        if ($students === false) {
            throw new Exception("Impossible de charger le fichier students.xml");
        }
        
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
        
        // Si étudiant non trouvé, utiliser des valeurs par défaut
        if (empty($studentData)) {
            $studentData = [
                'id' => $studentId,
                'name' => 'Étudiant Inconnu',
                'email' => '',
                'class' => 'Non spécifié'
            ];
        }
        
        // Charger les données de la séance
        $seanceData = [];
        
        if (file_exists($seancesFile)) {
            $seances = simplexml_load_file($seancesFile);
            if ($seances !== false) {
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
            }
        }
        
        // Préparer les données d'absence
        $this->absenceData = [
            'student_id' => $studentId,
            'student_name' => $studentData['name'],
            'student_email' => $studentData['email'],
            'student_class' => $studentData['class'],
            'seance_id' => $seanceId,
            'seance_module' => !empty($module) ? $module : ($seanceData['module'] ?? 'Non spécifié'),
            'seance_datetime' => !empty($date) ? $date : ($seanceData['datetime'] ?? date('Y-m-d H:i:s')),
            'teacher_id' => $teacherId,
            'timestamp' => date('Y-m-d H:i:s'),
            'type' => 'absence',
            'action' => 'marked',
            'base_path' => $this->basePath // Pour le DashboardNotifier
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
    
    /**
     * Récupérer les observateurs (pour débogage)
     */
    public function getObservers() {
        return $this->observers;
    }
    
    /**
     * Définir le chemin de base manuellement
     */
    public function setBasePath($path) {
        $this->basePath = rtrim($path, '/') . '/';
    }
}
?>