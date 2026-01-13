<?php
require_once __DIR__ . "../models/StudentModel.php";

class AdminController {
    private $studentModel;

    public function __construct() {
        $this->studentModel = new StudentModel("../data/students.xml");
    }

    public function addStudent($id, $name, $email, $class) {
        $this->studentModel->addStudent($id, $name, $email, $class);
    }

    public function deleteStudent($id) {
        $this->studentModel->deleteStudent($id);
    }

    public function getAllStudents() {
        return $this->studentModel->getAllStudents();
    }
}
?>
