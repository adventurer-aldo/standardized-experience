<?php require "connect.php"?>

<!DOCTYPE html>
<html lang="en">

<?php require "head.php"?>

<body><form action="new_quiz.php" method="get" id='quiz' autocomplete='off'>
<?php require 'return.php'?>
    <div id="page"><img src='https://i.ibb.co/dfdznVS/Untitled.png'><?php $subject = mysqli_fetch_assoc($conn->query('SELECT * FROM quiz ORDER BY rand() LIMIT 1'));?>
    <p class="bolding roman gapped">CURSO DE MEDICINA GERAL<br>DISCIPLINA DE <?php echo strtoupper($subject['subject']);?><br>TESTE PRÁTICO<br>DATA: <?php echo date('d/m/Y');?> <br>NOME<input type="text" class="inputtable calligraphy" name="uname"><br>APELIDO<input type="text" class="inputtable calligraphy" name="usurname"></p>
    <p class='bolding notice roman'>Escreva o seu Nome e Apelido em letras MAÍUSCULAS e LEGÍVEIS no início do Teste e em cada folha que compõe o Teste.<br>Não é permitido o porte de TELEMÓVEL, LAPTOP, nem qualquer APARELHO Electrónico, livro ou papel para além das Folhas do Teste.<br>Não estão autorizados a conversar, pedir ou trocar qualquer material.</p>
    <div id="questions" class="roman">
        <?php
        $alphas = range('A', 'Z');
        $questions_num = 0;
        $start_time = strtotime(date("m-d-Y h:i:s a"));
        $result = $conn->query("SELECT * FROM quiz 
        WHERE subject='".$subject['subject']."' ORDER BY rand() LIMIT 20");
        if (mysqli_num_rows($result) > 0){
            while ($questions = mysqli_fetch_assoc($result)) {
                $questions_num = $questions_num + 1;
                echo "<p>".$questions_num.". ".$questions['question']."</p>";
                switch ($questions['type']) {
                    case 'open':
                        echo "<input type='hidden' name='question".$questions_num."' value='".$questions['question']."'>";
                        echo "<input type=text class='inputtable inputtableans' name='answer".$questions_num."'>";
                        break;
                    case 'choice':
                        $decoys = explode('|',$questions['choices']);
                        $choice_num = rand(1,count($decoys));
                        $decoys = array_slice($decoys,0,$choice_num);
                        $choices = array_merge(array($questions['answer']),$decoys);
                        shuffle($choices);
                        foreach ($choices as $response) {
                            echo "<input type='hidden' name='question".$questions_num."' value='".$questions['question']."'>";
                            echo "<label for 'choice'>".$alphas[array_search($response,$choices)].". $response<input type='checkbox' class='singlecheck' name='answer$questions_num' value='$response'>&emsp;";
                        };
                        break;
                    case 'multichoice':
                        $decoys = explode('|',$questions['choices']);
                        $choice_num = rand(1,count($decoys));
                        $decoys = array_slice($decoys,0,$choice_num);
                        $choices = array_merge(array(explode('|',$questions['answer'])),$decoys);
                        shuffle($choices);
                        foreach ($choices as $response) {
                            echo "<input type='hidden' name='question".$questions_num."' value='".$questions['question']."'>";
                            echo "<label for 'choice'>".$alphas[array_search($response,$choices)].". $response<input type='checkbox' class='check' name='answer$questions_num' value='$response'>&emsp;";
                        };
                        break;
                    case 'veracity':
                        $decoys = explode('|',$questions['choices']);
                        $choice_num = rand(1,count($decoys));
                        $answer = explode("|",$questions['answer']);
                        if (count($answer) > 1) {
                            $choices = array_merge(array(explode('|',$questions['answer'])),$decoys);
                        } else {
                            $choices = array_merge(array($questions['answer']),$decoys);
                        };
                        shuffle($choices);
                        foreach ($choices as $response) {
                            echo "<input type='hidden' name='question".$questions_num."' value='".$questions['question']."'>";
                            echo "<label for 'choice'>".$alphas[array_search($response,$choices)].". $response<select class='veracity' name='answer$questions_num'>";
                            if (in_array($response,$answer)) {
                                echo "<option value='$response'>V</option><br>\n<option value=''>F</option><br>";
                            } else {
                                echo "<option value=''>V</option><br>\n<option value='$response'>F</option><br>";
                            };
                        };
                        break;
                };
            }   ;
        } else {
            echo "<p>There are no questions in this subject.</p>";
        };
        ?>
        <?php echo "<input type='hidden' name='quests' value='".$questions_num."'>";
        echo "<input type='hidden' name='subject' value='".$subject['subject']."'>";
        echo "<input type='hidden' name='time' value='".$start_time."'>";?>
        </form>
    </div><br>
        <br>
    <button id="submit" form='quiz' type='submit'>SUBMIT</button>

    </div>

    <!--<div id="like_button_container"></div>-->
    <script src="https://unpkg.com/react@17/umd/react.development.js" crossorigin></script>
    <script src="https://unpkg.com/react-dom@17/umd/react-dom.development.js" crossorigin></script>

    <!--<script src="test.js"></script>-->
</body>

</html>