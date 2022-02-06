<?php require "connect.php";
session_start();?>

<!DOCTYPE html>
<html lang="en">

<?php require "head.php"?>

<body><audio id="theme" autoplay loop><source id="fightpractice" src="audio/prac.mp3" type="audio/mpeg"></audio> <form action="new_quiz.php" method="post" id='quiz' autocomplete='off'>
<?php require 'return.php'?>
<script src="outro.js"></script>
    <div id="page"><img style='width: 209px;height: 183px;' src='https://i.ibb.co/2vpwYXR/Unti2tled.png'><?php $subject = $_SESSION['subjecto']['subject'];
    ( isset($_GET['subjecto']) ) ? $subject = $_GET['subjecto'] : $v = 0;?>
    <p class="bolding roman gapped">CURSO DE MEDICINA GERAL<br>DISCIPLINA DE <?php echo strtoupper($subject);?><br>TESTE PRÁTICO<br>DATA: <?php echo date('d/m/Y');?> <br>NOME<input type="text" class="inputtable calligraphy" name="uname"><br>APELIDO<input type="text" class="inputtable calligraphy" name="usurname"></p>
    <p class='bolding notice roman'>Escreva o seu Nome e Apelido em letras MAÍUSCULAS e LEGÍVEIS no início do Teste e em cada folha que compõe o Teste.<br>Não é permitido o porte de TELEMÓVEL, LAPTOP, nem qualquer APARELHO Electrónico, livro ou papel para além das Folhas do Teste.<br>Não estão autorizados a conversar, pedir ou trocar qualquer material.</p>
    <div id="questions" class="roman">
        <?php
        $alphas = range('A', 'Z');
        $numas = range(1, 100);
        $questions_num = 0;
        $_SESSION['time'] = 1+strtotime(date("m-d-Y h:i:s a"));
        $rande = rand(9,15);
        $result = $conn->query("SELECT * FROM quiz 
        WHERE subject='".$subject."' ORDER BY rand() LIMIT $rande");
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
                                echo "<option value='$response'>V</option><br>\n<option value=''>F</option></select><br>";
                            } else {
                                echo "<option value=''>V</option><br>\n<option value='$response'>F</option></select><br>";
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