<?php
    require "connect.php";
    session_start();
    error_reporting(E_ALL ^ E_NOTICE);  

    $questions_num = 0;
    $correct_answers = 0;
    $old_quests = intval($_POST["quests"]);
    $score = 0;
    $quizzes_done = mysqli_fetch_assoc($conn->query("SELECT quizzes_done FROM statistics"));
    $id = 1 + $quizzes_done['quizzes_done'];
    $time = $_SESSION['time'];
    $timenow = strtotime(date("Y:m:d H:i:s"));
    $total = $timenow - $time;
    while ($old_quests > 0) {
        ++$questions_num;
        if (gettype($_POST["answer".$questions_num]) == 'array') {
            $answer = implode("|",$_POST["answer".$questions_num]);
        } else {
            $answer = $_POST["answer".$questions_num];
        };
        $conn->query("INSERT INTO quizzes VALUES ('".$_POST["uname"]."','".$_POST["usurname"]."','".$_POST["subject"]."',$id,NULL, '".$_POST["question".$questions_num]."', '".$answer."', $total,$timenow)");
        $correctness = mysqli_fetch_assoc($conn->query("SELECT * FROM quiz WHERE question='".$_POST["question".$questions_num]."'"));
        if (explode("|",$answer) == explode("|",$correctness['answer']) ) {
            ++$correct_answers;
        };
        --$old_quests;
    };
    if ($correct_answers != 0) {
        $score = $correct_answers / $questions_num * 20;
    } else {
        $score = 0;
    };
    $conn->query("UPDATE statistics SET quizzes_done=$id, last_quiz_id=$id");
    $_SESSION['id'] = $id;
    header('Location: result.php');
?>