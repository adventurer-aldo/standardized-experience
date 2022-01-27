<?php require "connect.php";
session_start();
$id = $_SESSION['id'];?>

<!DOCTYPE html>
<html lang="en">

<?php require "head.php"?>

<body>
    <?php require 'return.php'?>
    <div id="page"><?php $quiz = mysqli_fetch_assoc($conn->query("SELECT * FROM quizzes WHERE id=$id LIMIT 1"));
    $testing = $conn->query("SELECT * FROM quizzes WHERE id=$id ORDER BY id DESC");?>
    <?php 
    $test_name = "8";
    $appenda = "<p class='bolding roman gapped'>CURSO DE MEDICINA GERAL<br>DISCIPLINA DE ".strtoupper($quiz['subject'])."<br> %s <br>DATA: ".date("d/m/Y",$quiz['date'])." <br>NOME<span class='inputtable'>".$quiz['name']."</span><br>APELIDO<span class='inputtable'>".$quiz['surname']."</span></p>
    <p class='bolding notice roman'>Escreva o seu Nome e Apelido em letras MAÍUSCULAS e LEGÍVEIS no início do Teste e em cada folha que compõe o Teste.<br>Não é permitido o porte de TELEMÓVEL, LAPTOP, nem qualquer APARELHO Electrónico, livro ou papel para além das Folhas do Teste.<br>Não estão autorizados a conversar, pedir ou trocar qualquer material.</p>";

    $appendb = "<p class='bolding roman'>INSTITUTO SUPERIOR DE CIÊNCIAS E TECNOLOGIA DE MOÇAMBIQUE<br>CURSO DE MEDICINA GERAL<br>Disciplina de ".$quiz['subject']."<br> %s - ".date("d/m/Y",$quiz['date'])."<br>Nome completo:<span class='inputtable'>".$quiz['name']."</span> Código:<span class='inputtable'>".$quiz['surname']."</span></p>
    <p class='bolding notice roman'>Leia atentamente as questões colocadas e responda a todas na folha de exercícios seguindo a ordem. Respostas a lápis não contam. O exame tem a duração de 90 minutos.</p>";

    ;if ($quiz['journey']=="a") {
        $test_name = "1º TESTE ESCRITO";
        echo "<img src='https://i.ibb.co/dfdznVS/Untitled.png'>";
        echo sprintf($appenda, $test_name);
    } elseif ($quiz['journey']=="b") {
        $test_name = "2º TESTE ESCRITO";
        echo "<img src='https://i.ibb.co/dfdznVS/Untitled.png'>";
        echo sprintf($appenda, $test_name);
    } elseif ($quiz['journey']=="c") {
        $test_name = "TESTE DE REPOSIÇÃO";
        echo "<img src='https://i.ibb.co/dfdznVS/Untitled.png'>";
        echo sprintf($appenda, $test_name);
    } elseif ($quiz['journey']=="exama") {
        $test_name = "EXAME NORMAL";
        echo sprintf($appendb, $test_name);
    } elseif ($quiz['journey']=="examb") {
        $test_name = "EXAME DE RECORRÊNCIA";
        echo sprintf($appendb, $test_name);
    } else {
        echo "<img src='https://i.ibb.co/dfdznVS/Untitled.png'>";
        $test_name = "TESTE PRÁTICO";
        echo sprintf($appenda, $test_name);
    };?>
    
    <div id="questions" class="roman">
        <?php
        $correct = 0;
        $questions_num = 0;
        $score = 0;
        $result = "w";
        if (mysqli_num_rows($testing) > 0) {
            while ($questions = mysqli_fetch_assoc($testing)) {
                $questions_num = $questions_num + 1;
                $icon = "x";
                $original = mysqli_fetch_assoc($conn->query("SELECT * FROM quiz WHERE question='".$questions['question']."'"));
                echo "<p";
                if ($original['answer'] == $questions['answer']) {
                    $result = "right";
                    ++$correct;
                    echo " class='right'";
                    $icon = "<i class='fas fa-check'></i>";
                } else {
                    $result = "wrong";
                    echo " class='wrong'";
                    $icon = "<i class='fas fa-times'></i><br><b>RESPOSTA CORRECTA: ".implode("&",explode("|",$original['answer']))."</b>";
                };
                
                echo ">".$questions_num.". ".$questions['question']."$icon</p>";
                    echo "<p class='inputtable $result'>".implode("&",explode("|",$questions['answer']))."</p>";
            };
        } else {
            echo "<p>There are no questions in this subject.</p>";
        };

        if ($correct == 0) {
            $score = 0;
        } else {
            $score = $correct / $questions_num * 20;
        };
        
        ?>
        
    <p class="grade"><?php echo number_format($score,2,',','');?>/20</p>
    </div><br>
        <br>
    <?php 
    if ($quiz['journey']="a") {
        echo "<p class='roman'>Obrigado</p>";
    } elseif ($quiz['journey']="b") {
        echo "<p class='roman'>Bom trabalho!</p>";
    } elseif ($quiz['journey']="c") {
        echo "<p class='roman'>Obrigado</p>";
    } elseif ($quiz['journey']="exama") {
        $test_name = "EXAME NORMAL";
        echo "<p class='roman'>Fim</p>";
    } elseif ($quiz['journey']="examb") {
        echo "<p class='roman'>Fim</p>";
    } else {
        echo "<p class='roman'>Bom trabalho!</p>";
    }
    ?>
    </div>

    <!--<div id="like_button_container"></div>-->
    <script src="https://unpkg.com/react@17/umd/react.development.js" crossorigin></script>
    <script src="https://unpkg.com/react-dom@17/umd/react-dom.development.js" crossorigin></script>

    <!--<script src="test.js"></script>-->
</body>

</html>