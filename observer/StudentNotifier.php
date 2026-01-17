<?php
require_once "ObserverInterface.php";

class StudentNotifier implements ObserverInterface
{
    // Déclarer la propriété
    private string $notificationsPath;

    public function __construct()
    {
        // Chemin vers le fichier notifications.xml
        $this->notificationsPath = __DIR__ . '/../data/notifications.xml';
    }

    // Implémenter la méthode update de l'interface
    public function update(string $studentId, string $message): void
    {
        // Vérifier si le fichier existe et n’est pas vide
        if (!file_exists($this->notificationsPath) || filesize($this->notificationsPath) === 0) {
            // Créer un XML vide
            $xml = new SimpleXMLElement('<?xml version="1.0"?><notifications></notifications>');
            // Sauvegarder pour créer le fichier
            $xml->asXML($this->notificationsPath);
        } else {
            $xml = simplexml_load_file($this->notificationsPath);
            if ($xml === false) {
                // Si échec, recréer un XML vide
                $xml = new SimpleXMLElement('<?xml version="1.0"?><notifications></notifications>');
            }
        }

        // Ajouter la notification
        $notif = $xml->addChild('notification');
        $notif->addChild('student_id', $studentId);
        $notif->addChild('message', $message);
        $notif->addChild('date', date('Y-m-d H:i:s'));

        // Sauvegarder le fichier XML
        $xml->asXML($this->notificationsPath);
    }
}
