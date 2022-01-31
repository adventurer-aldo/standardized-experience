<?php
    require "connect.php";
    session_start();

    $questions_num = 0;
    $correct_answers = 0;
    $old_quests = intval($_GET["quests"]);
    $score = 0;
    $quizzes_done = pg_fetch_assoc(pg_query($conn,"SELECT * FROM statistics"));
    $level = $quizzes_done['current_journey_progress'];
    $id = 1 + $quizzes_done['quizzes_done'];
    $active_journ = $quizzes_done['active_journey_id'];
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
    switch ($level) {
        case: 0
            $locos = "grade_1";
            break;
        case: 1
            $locos = "grade_2";
            break;
        case: 2
            $locos = "grade_reposition";
            break;
        case: 3
            $locos = "exam";
            break;
        case: 4
            $locos = "exam_reposition";
            break;
    };
    pg_query($conn,"UPDATE journeys SET $locos=$score WHERE id=$active_journ AND WHERE subject='".$_GET["subject"]."'");
    $hero = pg_fetch_assoc(pg_query($conn,"SELECT * FROM journeys WHERE id=$active_journ AND WHERE subject='".$_GET["subject"]."'"));
    if (pg_num_rows(pg_query($conn,"SELECT * FROM journeys WHERE id=$active_journ AND WHERE $locos=NULL")) == 0) {
        ++$level;
        if ($level == 2) {
            ++$level;
            if ((0.67*($hero['grade_1']+$hero["grade_2"]) + 0.33*$hero['grade_dissertation']) > 15) {
                pg_query($conn,"UPDATE journeys SET exam=20 WHERE id=$active_journ AND WHERE subject='".$_GET["subject"]."'");
                pg_query($conn,"UPDATE journeys SET exam_reposition=20 WHERE id=$active_journ AND WHERE subject='".$_GET["subject"]."'");
            };
        } elseif ($level == 4 && $score > 9.5) {
            pg_query($conn,"UPDATE journeys SET $locos=20 WHERE id=$active_journ AND WHERE subject='".$_GET["subject"]."'");
        };
        pg_query($conn,"UPDATE statistics SET current_journey_progress=$level");    
    };
    pg_query($conn,"UPDATE statistics SET quizzes_done=$id, last_quiz_id=$id");
    $_SESSION['id'] = $id;
    header("Location: result.php");
?>