<?php require "connect.php"?>

<!DOCTYPE html>
<html lang="en">

<?php require "head.php"?>

<body>
    <div id="page">
        <?php require 'head_branch.php'?>
        <?php $stats = mysqli_fetch_assoc($conn->query("SELECT * FROM statistics"));
        $id_data = mysqli_fetch_assoc($conn->query("SELECT * from quizzes WHERE id=".$stats['last_quiz_id']." LIMIT 1"));
        $id = $stats['last_quiz_id'];
        $testing = $conn->query("SELECT * FROM quizzes WHERE id=$id ORDER BY id DESC");
        $correct = 0;
        $questions_num = 0;
        $score = 0;
        if (mysqli_num_rows($testing) > 0) {
            while ($questions = mysqli_fetch_assoc($testing)) {
                $questions_num = $questions_num + 1;
                $original = mysqli_fetch_assoc($conn->query("SELECT * FROM quiz WHERE question='".$questions['question']."'"));
                if ($original['answer'] == $questions['answer']) {
                    ++$correct;
                } ;
                
            };
        };

        if ($correct == 0) {
            $score = 0;
        } else {
            $score = $correct / $questions_num * 20;
        };        
        ?>
        <p style='float:right; max-width: 300px; padding-right: 40px;'>O seu último teste foi de <b><?php echo $id_data['subject']?></b>.<br>A sua nota foi <?php echo number_format($score,2,',','')?> valor(es).<br>
    <br><?php 
    if ($score <= 6) {
        echo "Mas...que vergonha...";
    } elseif ($score <= 10) {
        echo "Bem. Pelo menos dá para passar com isto.";
    } elseif ($score <= 14) {
        echo "Nossa. Isso foi legal...Você pode fazer melhor!";
    } elseif ($score <= 17) {
        echo "Se liga, para Medicina esta nota é muito legal! Mandou bem!!!";
    } elseif ($score == 20) {
        echo "<b>Perfeito</b>. Ninguém poderá te derrotar. Você é invencivel!";
    };
    ?></p>
    <img src="https://4.bp.blogspot.com/-EjZ4ENmfIkc/V9PE9nu6eKI/AAAAAAAA9ko/I1hPkXoivi4WWdibdh2JQw1kgeVXwu0AgCLcB/s450/kjhou_seifuku.png" id='board'>

    </div>

    <!--<div id="like_button_container"></div>-->
    <script src="https://unpkg.com/react@17/umd/react.development.js" crossorigin></script>
    <script src="https://unpkg.com/react-dom@17/umd/react-dom.development.js" crossorigin></script>

    <!--<script src="test.js"></script>-->
</body>

</html>