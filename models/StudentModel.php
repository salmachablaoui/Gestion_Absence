<?php
require_once __DIR__ . "XmlManager.php";

class StudentModel extends XmlManager {

    public function addStudent($id, $name, $email, $class) {
        $student = $this->xml->addChild("student");
        $student->addAttribute("id", $id);
        $student->addChild("name", $name);
        $student->addChild("email", $email);
        $student->addChild("class", $class);
        $student->addChild("totalAbsences", 0);
        $this->save();
    }

    public function deleteStudent($id) {
        foreach ($this->xml->student as $student) {
            if ((int)$student['id'] === (int)$id) {
                $dom = dom_import_simplexml($student);
                $dom->parentNode->removeChild($dom);
                break;
            }
        }
        $this->save();
    }

    public function getAllStudents() {
        return $this->xml->student;
    }
}
?>
