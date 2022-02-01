<?php require "connect.php"?>

<!DOCTYPE html>
<html lang="en">

<?php require "head.php"?>

<body>
    <?php $stats = pg_fetch_assoc(pg_query($conn,"SELECT * FROM statistics"));
    $level = $stats['current_journey_progress'];
    if ($stats['active_journey_id'] == 0) {
        $ausrc = "home";
    } else {
        switch ($level) {
            case 0:
                $ausrc = "prep";
                break;
            case 1:
                $ausrc = "prep2";
                break;
            case 2:
                $ausrc = "prep2";
                break;
            case 3:
                $ausrc = "prepexam";
                break;
            case 4:
                $ausrc = "prepexam";
                break;
        };
    };
    echo "<audio autoplay loop><source src='audio/$ausrc.mp3' type='audio/mpeg'></audio>";?>
     
    <div id="page">
        <?php require 'head_branch.php'?>
        <?php $stats = pg_fetch_assoc(pg_query($conn,"SELECT * FROM statistics"));
        $id_data = pg_fetch_assoc(pg_query($conn,"SELECT * from quizzes WHERE id=".$stats['last_quiz_id']." LIMIT 1"));
        $id = $stats['last_quiz_id'];
        $testing = pg_query($conn,"SELECT * FROM quizzes WHERE id=$id ORDER BY id DESC");
        $correct = 0;
        $questions_num = 0;
        $score = 0;
        if (pg_num_rows($testing) > 0) {
            while ($questions = pg_fetch_assoc($testing)) {
                $questions_num = $questions_num + 1;
                $original = pg_fetch_assoc(pg_query($conn,"SELECT * FROM quiz WHERE question='".$questions['question']."'"));
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
        <form id='newjourney' action='newjourney.php'></form>
        <p style='float:right; max-width: 300px; padding-right: 40px;'>O seu último teste foi de <b><?php echo $id_data['subject']?></b>.<br>A sua nota foi <?php echo number_format($score,2,',','')?> valor(es).<br>
    <br><?php 
    if ($score == 20) {
        echo "<b>Perfeito</b>. Ninguém poderá te derrotar. Você é invencivel!";
    } elseif ($score >= 17) {
        echo "Se liga, para Medicina esta nota é muito legal! Mandou bem!!!";
    } elseif ($score >= 15) {
        echo "Nossa. Isso foi legal...Você pode fazer melhor!";
    } elseif ($score >= 10) {
        echo "Bem. Pelo menos dá para passar com isto.";
    } elseif ($score >= 7) {
        echo "Mas...que vergonha...";
    } elseif ($score < 7) {
        echo "...Temos um caminho realmente longo pela frente.";
    };
    
    if ($stats["active_journey_id"] == 0) {
        echo "<br><br>Parece que você não está em nenhuma jornada no momento. <button id='newjour' type='submit' form='newjourney'>Começe uma já!</button>";    
    };
    ?></p>
    <img src="https://4.bp.blogspot.com/-EjZ4ENmfIkc/V9PE9nu6eKI/AAAAAAAA9ko/I1hPkXoivi4WWdibdh2JQw1kgeVXwu0AgCLcB/s450/kjhou_seifuku.png" id='board'>
    <br>
    <span id="journeys">
    <table class="tg">
<thead>
  <tr>
    <th class="tg-tp8o tabsubj">Disciplina</th>
    <th class="tg-tp8o tabprog" colspan="7">Progresso da Jornada</th>
  </tr>
</thead>
<tbody>
    <form id='realdealer' action='test.php' method='get'></form>
    <form id='practicioner' action='practice.php' method='get'></form>
    <?php 
    $current_id = $stats["active_journey_id"];
    $journeys = pg_query($conn,"SELECT * FROM journeys WHERE id=$current_id");
    $num_rows = 0;
    $level = pg_fetch_assoc(pg_query($conn,"SELECT * FROM statistics"))['current_journey_progress'];
    if (pg_num_rows($journeys) > 0) {
        while ($journey = pg_fetch_assoc($journeys)) {
            ++$num_rows;

            $subj = $journey['subject'];
            if ($journey['grade_1'] == null) { 
                ($level == 0) ? $grade_1 = "
                <button class='tbdat' name='subjecto' form='realdealer' type='submit' value='$subj'>Teste 1<br>---</button>" : $grade_1 = "Teste 1<br>---";
            } else {
                $grade_1 = "Teste 1<br>".$journey['grade_1'] ;
            };

            if ($journey['grade_2'] == null) { 
                ($level == 1) ? $grade_2 = "
                <button class='tbdat' name='subjecto' form='realdealer' type='submit' value='$subj'>Teste 2<br>---</button>" : $grade_2 = "Teste 2<br>---";
            } else {
                $grade_2 = "Teste 2<br>".$journey['grade_2'] ;
            };

            if ($journey['grade_reposition'] == null) { 
                ($level == 2) ? $grade_reposition = "
                <button class='tbdat' name='subjecto' form='realdealer' type='submit' value='$subj'>Teste de Reposição<br>---</button>" : $grade_reposition = "Teste de Reposição<br>---";
            } else {
                $grade_reposition = "Teste de Reposição<br>".$journey['grade_reposition'] ;
            };

            ($journey['grade_dissertation'] == null) ? $grade_dissertation = "---" : $grade_dissertation = $journey['grade_dissertation'];

            if ($journey['grade_1'] == null || $journey['grade_2'] == null) {
                $final = "---" ;
             } else {
                $final = 0.67*($grade_1+$grade_2) + 0.33*$grade_dissertation;
            };

            if ($journey['exam'] == null) { 
                ($level == 3 && $final > 9.5) ? $grade_exam = "
                <button class='tbdat' name='subjecto' form='realdealer' type='submit' value='$subj'>Exame<br>---</button>" : $grade_exam = "Exame<br>---";
            } else {
                $grade_exam = "Exame<br>".$journey['exam'] ;
            };
            
            if ($journey['exam_reposition'] == null) { 
                ($level == 4 && $grade_exam < 9.5) ? $grade_recorrence = "
                <button class='tbdat' name='subjecto' form='realdealer' type='submit' value='$subj'>Recorrência<br>---</button>" : $grade_recorrence = "Recorrência<br>---";
            } else {
                $grade_recorrence = "Recorrência<br>".$journey['exam_reposition'] ;
            };
            
            #($journey['grade_2'] == null) ? $grade_2 = "---" : $grade_2 = $journey['grade_2'];
            #($journey['grade_reposition'] == null) ? $grade_reposition = "---" : $grade_2 = $journey['grade_reposition'];
            #($journey['exam'] == null) ? $grade_exam = "---" : $grade_exam = $journey['exam'];
            #($journey['exam_reposition'] == null) ? $grade_recorrence = "---" : $grade_recorrence = $journey['exam_reposition'];

            echo "<tr>
            <td class='tg-wp8o row$num_rows subj'><button class='tbdat' name='subjecto' form='practicioner' type='submit' value='$subj'><b>$subj</b></button></td>
            <td class='tg-wp8o row$num_rows test1'>$grade_1</td>
            <td class='tg-wp8o row$num_rows test2'>$grade_2</td>
            <td class='tg-wp8o row$num_rows extra'>Dissertação<br>$grade_dissertation</td>
            <td class='tg-wp8o row$num_rows repo'>$grade_reposition</td>
            <td class='tg-wp8o row$num_rows final'>Média Final<br>$final</td>
            <td class='tg-wp8o row$num_rows exam'>$grade_exam</td>
            <td class='tg-wp8o row$num_rows reco'>$grade_recorrence</td>
          </tr>
            ";

        }
    };
    ?>
  
</tbody>
</table> </span>
    </div>

    <!--<div id="like_button_container"></div>-->
    <script src="https://unpkg.com/react@17/umd/react.development.js" crossorigin></script>
    <script src="https://unpkg.com/react-dom@17/umd/react-dom.development.js" crossorigin></script>

    <!--<script src="test.js"></script>-->
</body>

</html>