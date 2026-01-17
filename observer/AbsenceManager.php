<?php
require_once "ObserverInterface.php";

class AbsenceManager
{
    private array $observers = [];
    private string $absencesPath;

    public function __construct()
    {
        $this->absencesPath = __DIR__ . '/../data/absences.xml';
        // Créer le fichier s'il n'existe pas
        if (!file_exists($this->absencesPath) || filesize($this->absencesPath) === 0) {
            $xml = new SimpleXMLElement('<?xml version="1.0"?><absences></absences>');
            $xml->asXML($this->absencesPath);
        }
    }

    // Ajouter un observateur
    public function attach(ObserverInterface $observer): void
    {
        $this->observers[] = $observer;
    }

    // Notifier tous les observateurs
    private function notify(string $studentId, string $message): void
    {
        foreach ($this->observers as $observer) {
            $observer->update($studentId, $message);
        }
    }

    // Marquer une absence
    public function markAbsence(string $studentId, string $seanceId): void
{
    $xml = simplexml_load_file($this->absencesPath);

    // Vérifier si l'absence existe déjà pour cet étudiant et cette séance
    $exists = false;
    foreach ($xml->absence as $absence) {
        if ((string)$absence->studentId === $studentId && (string)$absence->seanceId === $seanceId) {
            $exists = true;
            break;
        }
    }

    // Si elle existe déjà, ne rien faire
    if ($exists) {
        return;
    }

    // Ajouter une nouvelle absence
    $absence = $xml->addChild('absence');
    $absence->addAttribute('id', uniqid('a'));
    $absence->addChild('studentId', $studentId);
    $absence->addChild('seanceId', $seanceId);
    $absence->addChild('date', date('Y-m-d'));
    $absence->addChild('hours', date('H:i'));

    // Sauvegarder le fichier XML
    $xml->asXML($this->absencesPath);

    // Notifier les observateurs
    $this->notify(
        $studentId,
        "Absence enregistrée pour la séance $seanceId"
    );
}

}
