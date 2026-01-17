<?php
session_start();

require_once "../../observer/AbsenceManager.php";
require_once "../../observer/StudentNotifier.php";

// Multilang
$langFile = "../../lang/" . ($_SESSION['lang'] ?? "fr") . ".php";
if (file_exists($langFile)) {
    $langs = include $langFile;
} else {
    $langs = [];
}

// Vérification rôle
if (!isset($_SESSION['user']) || $_SESSION['user']['role'] !== 'teacher') {
    header("Location: ../../login.php");
    exit;
}

$absenceManager = new AbsenceManager();
$studentNotifier = new StudentNotifier();
$absenceManager->attach($studentNotifier);

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $seanceId = $_POST['seance_id'];
    $absentStudents = $_POST['absent_students'] ?? [];

    foreach ($absentStudents as $studentId) {
        // Message multilingue
        $message = sprintf(
            $langs["notifications"]["absence"] ?? "Absence enregistrée pour la séance %s",
            $seanceId
        );

        // Marquer l'absence et notifier
        $absenceManager->markAbsence($studentId, $seanceId);
    }
}

header("Location: dashboard.php");
exit;
