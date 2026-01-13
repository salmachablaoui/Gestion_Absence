<?php
class XmlManager {
    private $filePath;
    private $xml;

    public function __construct($filePath) {
        // Transforme le chemin relatif en absolu
        $this->filePath = realpath($filePath);

        // Si le fichier n'existe pas encore, on prend le chemin absolu sans realpath
        if (!$this->filePath) {
            $this->filePath = __DIR__ . "/../data/" . basename($filePath);
        }

        // Vérifie si le fichier existe
        if (file_exists($this->filePath)) {
            $this->xml = simplexml_load_file($this->filePath);
            if ($this->xml === false) {
                $this->initializeXml();
            }
        } else {
            $this->initializeXml();
        }
    }

    private function initializeXml() {
        if (strpos($this->filePath, 'users.xml') !== false) $root = "users";
        elseif (strpos($this->filePath, 'students.xml') !== false) $root = "students";
        elseif (strpos($this->filePath, 'teachers.xml') !== false) $root = "teachers";
        elseif (strpos($this->filePath, 'classes.xml') !== false) $root = "classes";
        elseif (strpos($this->filePath, 'absences.xml') !== false) $root = "absences";
        else $root = "root";

        $this->xml = new SimpleXMLElement("<$root></$root>");

        // Assure que le dossier data existe
        $dir = dirname($this->filePath);
        if (!is_dir($dir)) {
            mkdir($dir, 0777, true); // crée le dossier si inexistant
        }

        $this->save();
    }

    public function getAll() {
        return $this->xml;
    }

    public function save() {
        $this->xml->asXML($this->filePath);
    }

    public function addUser($id, $role, $name, $email, $password) {
        $user = $this->xml->addChild("user");
        $user->addAttribute("id", $id);
        $user->addAttribute("role", $role);
        $user->addChild("name", $name);
        $user->addChild("email", $email);
        $user->addChild("password", $password);
        $this->save();
    }
}
?>
