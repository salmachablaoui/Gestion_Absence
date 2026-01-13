<?php
require_once __DIR__ . "/../models/XmlManager.php";

class AuthController {

    private $xmlManager;

    public function __construct() {
        // Chemin ABSOLU vers users.xml
        $this->xmlManager = new XmlManager(
            __DIR__ . "/../data/users.xml"
        );
    }

    public function login($email, $password) {
        $users = $this->xmlManager->getAll();

        // Sécurité : si vide
        if (!isset($users->user)) {
            return false;
        }

        foreach ($users->user as $user) {
            if (
                (string)$user->email === $email &&
                (string)$user->password === $password
            ) {
                return [
                    "id" => (string)$user["id"],
                    "role" => (string)$user["role"],
                    "email" => (string)$user->email
                ];
            }
        }
        return false;
    }
}
