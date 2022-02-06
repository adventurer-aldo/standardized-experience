<?php
    require "connect.php";
    session_start();

    $questions_num = 0;
    $correct_answers = 0;
    $old_quests = intval($_POST["quests"]);
    $score = 0;
    $quizzes_done = mysqli_fetch_assoc($conn->query("SELECT * FROM statistics"));
    $level = $quizzes_done['current_journey_progress'];
    $id = 1 + $quizzes_done['quizzes_done'];
    $active_journ = $quizzes_done['active_journey_id'];
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
        $conn->query("INSERT INTO quizzes VALUES ('".$_POST["uname"]."','".$_POST["usurname"]."','".$_POST["subject"]."',$id,$level, '".$_POST["question".$questions_num]."', '".$answer."', $total,$timenow)");
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
    switch ($level) {
        case 0:
            $locos = "grade_1";
            break;
        case 1:
            $locos = "grade_2";
            break;
        case 2:
            $locos = "grade_reposition";
            break;
        case 3:
            $locos = "exam";
            break;
        case 4:
            $locos = "exam_reposition";
            break;
    };
    $sub = $_POST['subject'];
    $conn->query("UPDATE journeys SET $locos=$score WHERE id=$active_journ AND subject='$sub'");
    $hero = mysqli_fetch_assoc($conn->query("SELECT * FROM journeys WHERE id=$active_journ AND subject='$sub'"));
    if ($hero['grade_1'] != null && $hero['grade_2'] != null) {
        $conn->query("UPDATE journeys SET grade_reposition=0 WHERE id=$active_journ AND subject='".$_POST["subject"]."'");
    };
    if ($level == 1 || $level == 2) {
        if ((0.67*(($hero['grade_1']+$hero["grade_2"])/2) + 0.33*$hero['grade_dissertation']) > 15) {
            $conn->query("UPDATE journeys SET exam=20 WHERE id=$active_journ AND subject='".$_POST["subject"]."'");
            $conn->query("UPDATE journeys SET exam_reposition=20 WHERE id=$active_journ AND subject='".$_POST["subject"]."'");
        } elseif ((0.67*(($hero['grade_1']+$hero["grade_2"])/2) + 0.33*$hero['grade_dissertation']) < 9.5) {
            $conn->query("UPDATE journeys SET exam_reposition=0 WHERE id=$active_journ AND subject='".$_POST["subject"]."'");
            $conn->query("UPDATE journeys SET exam=0 WHERE id=$active_journ AND subject='".$_POST["subject"]."'");
        };
    } elseif ($level == 3 && $score > 9.5) {
        $conn->query("UPDATE journeys SET exam_reposition=20 WHERE id=$active_journ AND subject='".$_POST["subject"]."'");
    };
    $remainder = $conn->query("SELECT * FROM journeys WHERE id=$active_journ AND $locos IS NULL");
    if (mysqli_num_rows($remainder) == 0) {
        do {
            ++$level;
            $conn->query("UPDATE statistics SET current_journey_progress=$level"); 
            switch ($level) {
                case 0:
                    $locos = "grade_1";
                    break;
                case 1:
                    $locos = "grade_2";
                    break;
                case 2:
                    $locos = "grade_reposition";
                    break;
                case 3:
                    $locos = "exam";
                    break;
                case 4:
                    $locos = "exam_reposition";
                    break;
            };
            $remainder = $conn->query("SELECT * FROM journeys WHERE id=$active_journ AND $locos IS NULL");   
        } while (mysqli_num_rows($remainder) == 0 && $level <= 4);
    }
    if ($level > 4) {$conn->query("UPDATE statistics SET active_journey_id=0");};
    $conn->query("UPDATE statistics SET quizzes_done=$id, last_quiz_id=$id");
    $_SESSION['id'] = $id;
    header('Location: result.php');
?>