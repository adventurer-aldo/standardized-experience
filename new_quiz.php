<?php
    require "connect.php";
    session_start();

    $questions_num = 0;
    $correct_answers = 0;
    $old_quests = intval($_GET["quests"]);
    $score = 0;
    $quizzes_done = pg_fetch_assoc(pg_query($conn,"SELECT quizzes_done FROM statistics"));
    $id = 1 + $quizzes_done['quizzes_done'];
    $time = $_SESSION['time'];
    $timenow = strtotime(date("Y:m:d H:i:s"));
    $total = $timenow - $time;
    while ($old_quests > 0) {
        ++$questions_num;
        if (gettype($_GET["answer".$questions_num]) == 'array') {
            $answer = implode("|",$_GET["answer".$questions_num]);
        } else {
            $answer = $_GET["answer".$questions_num];
        };
        pg_query($conn,"INSERT INTO quizzes VALUES ('".$_GET["uname"]."','".$_GET["usurname"]."','".$_GET["subject"]."',$id,NULL, '".$_GET["question".$questions_num]."', '".$answer."', $total,$timenow)");
        $correctness = pg_fetch_assoc(pg_query($conn,"SELECT * FROM quiz WHERE question='".$_GET["question".$questions_num]."'"));
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
    pg_query($conn,"UPDATE statistics SET quizzes_done=$id, last_quiz_id=$id");
    $_SESSION['id'] = $id;
    header("Location: result.php");
?>