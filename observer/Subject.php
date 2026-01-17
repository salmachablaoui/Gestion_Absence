<?php
interface Subject {
    public function attach(Observer $observer);
    public function notify();
}
