<?php
// observers/Subject.php

interface Subject {
    public function attach(ObserverInterface $observer);
    public function detach(ObserverInterface $observer);
    public function notify();
}
?>