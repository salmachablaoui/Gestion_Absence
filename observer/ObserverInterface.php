<?php
interface ObserverInterface
{
    public function update(string $studentId, string $message): void;
}
