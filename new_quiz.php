<?php
    require "connect.php";
    session_start();

    $questions_num = 0;
    $correct_answers = 0;
    $old_quests = intval($_GET["quests"]);
    $score = 0;
    $quizzes_done = mysqli_fetch_assoc($conn->query("SELECT quizzes_done FROM statistics"));
    $id = 1 + $quizzes_done['quizzes_done'];
    while ($old_quests > 0) {
        ++$questions_num;
        $conn->query("INSERT INTO quizzes VALUES ('".$_GET["uname"]."','".$_GET["usurname"]."','".$_GET["subject"]."',$id,NULL, '".$_GET["question".$questions_num]."', '".$_GET["answer".$questions_num]."', ".strtotime(date("m-d-Y h:i:s a"))-intval($_GET["time"]).",".strtotime(date("Y:m:d H:i:s")).")");
        $correctness = mysqli_fetch_assoc($conn->query("SELECT * FROM quiz WHERE question='".$_GET["question".$questions_num]."'"));
        if ($correctness['answer']==$_GET["answer".$questions_num]) {
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
    header("Location: result.php");
?>