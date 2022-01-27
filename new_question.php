<?php
    require "connect.php";
    $question = $_GET['question'];
    $answer = $_GET['answer'];
    $subject = $_GET['subject'];
    $conn->query("INSERT INTO quiz VALUES ('$subject','open','$question',NULL,'$answer',NULL)");
    header("Location: data.php");
?>