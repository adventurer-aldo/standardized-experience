<?php
    require "connect.php";
    session_start();
    $question = $_GET['question'];
    $answer = $_GET['answer'];
    $subject = $_GET['subject'];
    $type = $_GET['type'];
    $choices = $_GET['choices'];
    $level = $_GET['level'];
    $_SESSION['type']=$_GET['type'];
    $_SESSION['subject']=$_GET['subject'];
    $_SESSION['level']=$_GET['level'];
    if ($question == '') {
        $_SESSION['error']= "There was no question.";
        header("Location: data.php");
    } elseif ($answer = '') {
        $_SESSION['error']= "There was no answer.";
        header("Location: data.php");
    } elseif (($type == 'choice' or $type == 'multichoice') and $choices == 'NULL') {
        $_SESSION['error']= "Do choices properly.";
        header("Location: data.php");
    } else {
        $_SESSION['error']='';
        $answer = $_GET['answer'];
        $conn->query("INSERT INTO quiz (subject,type,question,choices,answer,level) VALUES ('$subject','$type','$question', '$choices','$answer',$level)");

        $temp = mysqli_fetch_assoc($conn->query("SELECT questions FROM statistics"));
        $questions = ++$temp['questions'];
        $conn->query("UPDATE statistics SET questions = $questions");

        $blast = explode('|',$answer);
        header("Location: data.php");
    }
?>