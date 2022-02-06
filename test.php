<?php require "connect.php";
session_start();?>

<!DOCTYPE html>
<html lang="en">

<?php require "head.php"?>

<body><form action="new_test.php" method="post" id='quiz' autocomplete='off'>
<?php require 'return.php'?>
    <div id="page"><img style='width: 209px;height: 183px;' src='https://i.ibb.co/2vpwYXR/Unti2tled.png'><?php $subject = $_SESSION['subjecto']['subject'];
    ( isset($_GET['subjecto']) ) ? $subject = $_GET['subjecto'] : $v = 0;
    $stats = mysqli_fetch_assoc($conn->query("SELECT * FROM statistics"));
    $progress = $stats['current_journey_progress'];
    if ($progress == 0) {
        $level = 1; // 1st Test
        echo "<script src='test_time.js'></script>";
        $_SESSION['level'] = 1;
        $test_name = "1º TESTE ESCRITO";
        $aud_src = "test1";
    } elseif ($progress == 1 ) {
        $level = 2; // 2nd Test
        echo "<script src='test_time.js'></script>";
        $_SESSION['level'] = 2;
        $test_name = "2º TESTE ESCRITO";
        $aud_src = "test2";
    } else if ($progress == 2) {
        $_SESSION['level'] = 3;
        $level = 3; // Reposition
        echo "<script src='test_time.js'></script>";
        $test_name = "TESTE DE REPOSIÇÃO";
        $aud_src = "test2";
    } else if ($progress == 3) {
        $_SESSION['level'] = 4;
        $level = 4; // Exam
        echo "<script src='exam_time.js'></script>";
        $test_name = "EXAME NORMAL";
        $aud_src = "exam";
    } else if ($progress == 4) {
        $_SESSION['level'] = 5;
        $level = 5; // Recorrence
        echo "<script src='exam_time.js'></script>";
        $test_name = "EXAME DE RECORRÊNCIA";
        $aud_src = "examrec";
    };
    echo "<audio id='theme' autoplay loop><source id='$aud_src' src='audio/$aud_src.mp3' type='audio/mpeg'></audio>";

    if ($level < 4) {
        echo "<p class='bolding roman gapped'>CURSO DE MEDICINA GERAL<br>DISCIPLINA DE ".strtoupper($subject)."<br>$test_name<br>DATA: ".date('d/m/Y')."<br>NOME<input type='text' class='inputtable calligraphy' name='uname'><br>APELIDO<input type='text' class='inputtable calligraphy' name='usurname'></p>
        <p class='bolding notice roman'>Escreva o seu Nome e Apelido em letras MAÍUSCULAS e LEGÍVEIS no início do Teste e em cada folha que compõe o Teste.<br>Não é permitido o porte de TELEMÓVEL, LAPTOP, nem qualquer APARELHO Electrónico, livro ou papel para além das Folhas do Teste.<br>Não estão autorizados a conversar, pedir ou trocar qualquer material.</p>";
    } else {
      echo  "<p class='bolding roman'>STANDARDIZED EXPERIENCE<br>CURSO DE MEDICINA GERAL<br>Disciplina de $subject<br> $test_name - ".date("d/m/Y")."<br>Nome completo:<input type='text' class='inputtable calligraphy' name='uname'> Código:<input type='text' class='inputtable calligraphy' name='usurname'></p>
    <p class='bolding notice roman'>Leia atentamente as questões colocadas e responda a todas na folha de exercícios seguindo a ordem. Respostas a lápis não contam. O exame tem a duração de 90 minutos.</p>";
    };
    ?>
    
    <div id="questions" class="roman">
        <?php
        $alphas = range('A', 'Z');
        $numas = range(1, 100);
        $questions_num = 0;
        $_SESSION['time'] = 1+strtotime(date("m-d-Y h:i:s a"));
        
        switch ($level) {
            case 1:
                $rande = rand(20,30);
                $result = $conn->query("SELECT * FROM quiz 
                WHERE subject='$subject' AND level=1 ORDER BY rand() LIMIT $rande");
                break;
            case 2:
                $rande = rand(10,20);
                $rande2 = rand(1,9);
                $result = $conn->query("(SELECT * FROM quiz 
                WHERE subject='$subject' AND level=2 ORDER BY rand() LIMIT $rande)
                UNION ALL
                (SELECT * FROM quiz
                WHERE subject='$subject' AND level=1 ORDER BY rand() LIMIT $rande2)
                ORDER BY rand()");
                break;
            case 3:
                $rande = rand(15,30);
                $result = $conn->query("SELECT * FROM quiz 
                WHERE subject='$subject' AND (level=1 OR level=2) 
                ORDER BY rand() LIMIT $rande");
                break;
            case 4:
                $rande = rand(5,30);
                $rande2 = rand(10,20);
                $result = $conn->query("(SELECT * FROM quiz 
                WHERE subject='$subject' AND level=3 ORDER BY rand() LIMIT $rande)
                UNION ALL
                (SELECT * FROM quiz
                WHERE subject='$subject' AND (level=1 OR level=2) ORDER BY rand() LIMIT $rande2)
                ORDER BY rand()");
                break;
            case 5:
                $rande = rand(30,100);
                $result = $conn->query("SELECT * FROM quiz 
                WHERE subject='$subject' ORDER BY rand() LIMIT $rande");
                break;
        }
        if (mysqli_num_rows($result) > 0){
            while ($questions = mysqli_fetch_assoc($result)) {
                $questions_num = $questions_num + 1;
                echo "<p>".$questions_num.". ".$questions['question']."</p>";
                echo "<input type='hidden' name='question".$questions_num."' value='".$questions['question']."'>";
                switch ($questions['type']) {
                    case 'open':
                        echo "<input type=text class='inputtable inputtableans' name='answer".$questions_num."'>";
                        break;
                    case 'choice':
                        $decoys = explode('|',$questions['choices']);
                        $choice_num = rand(1,count($decoys));
                        $decoys = array_slice($decoys,0,$choice_num);
                        $choices = array_merge(array($questions['answer']),$decoys);
                        shuffle($choices);
                        foreach ($choices as $response) {
                            echo "<label for 'choice'>".$alphas[array_search($response,$choices)].". $response</label><input type='checkbox' class='singlecheck' name='answer$questions_num' value='$response'>&emsp;";
                        };
                        break;
                    case 'multichoice':
                        $decoys = explode('|',$questions['choices']);
                        $choice_num = rand(1,count($decoys));
                        $decoys = array_slice($decoys,0,$choice_num);
                        $choices = array_merge(explode('|',$questions['answer']),$decoys);
                        shuffle($choices);
                        foreach ($choices as $response) {
                            echo "<label for 'choice'>".$alphas[array_search($response,$choices)].". $response</label><input type='checkbox' class='check' name='answer".$questions_num."[]' value='$response'>&emsp;";
                        };
                        break;
                    case 'veracity':
                        $decoys = explode('|',$questions['choices']);
                        $answer = explode("|",$questions['answer']);
                        $choices = array_merge($answer,$decoys);
                        shuffle($choices);
                        foreach ($choices as $response) {
                            echo "<label for 'choice'>".$alphas[array_search($response,$choices)].". </label>$response<select class='veracity' name='answer".$questions_num."[]'>";
                            if (in_array($response,$answer)) {
                                echo "<option value='$response'>V</option><br>\n<option>F</option></select><br>";
                            } else {
                                echo "<option>V</option><br>\n<option value='$response'>F</option></select><br>";
                            };
                        };
                        break;
                    case 'caption':
                        $answer = explode("|",$questions['answer']);
                        foreach ($answer as $response) {
                            echo "<label for choice>".$alphas[array_search($response,$answer)].".</label> <input type='text' class='caption' name='answer".$questions_num."[]'><br>";
                        };
                    break;
                };
            }   ;
        } else {
            echo "<p>There are no questions in this subject.</p>";
        };
        ?>
        <?php echo "<input type='hidden' name='quests' value='$questions_num'>";
        echo "<input type='hidden' name='subject' value='$subject'>";?><br>
        <br>
        <button id="btnSubmit" type='submit' >SUBMIT</button>
        </form>
    </div>
    
    <p id="demo"></p>
    </div>

    <!--<div id="like_button_container"></div>-->
    <script src="https://unpkg.com/react@17/umd/react.development.js" crossorigin></script>
    <script src="https://unpkg.com/react-dom@17/umd/react-dom.development.js" crossorigin></script>

    <!--<script src="test.js"></script>-->
</body>

</html>