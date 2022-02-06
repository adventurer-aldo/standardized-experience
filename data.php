<?php require "connect.php";
session_start();
if (!isset($_SESSION['subject'])) {
    $_SESSION['subject'] = "no";
};
if (!isset($_SESSION['level'])) {
    $_SESSION['level'] = "no";
};
if (!isset($_SESSION['type'])) {
  $_SESSION['type'] = "";
};
if (!isset($_SESSION['error'])) {
    $_SESSION['error'] = "";
};?>

<!DOCTYPE html>
<html lang="en">

<?php require "head.php"?>

<body>
  <script src="datapages.js"></script>
    <div id="page">
        <?php require 'head_branch.php';echo "<p id='warning'>".$_SESSION['error']."</p>"?>
        <form action='new_question.php' method='get' id='question' autocomplete='off'><div class='leftal'>
            <label for 'question'><b>Question:</b></label><input type=text name='question' class='questionnable' required><br>
            <label for 'answer'><b>Answer:</b></label><input type=text name='answer' class='questionnable' required><br>
            <label for 'choices'><b>Choices:</b><input type=text name='choices' class='questionnable' value='NULL' required><br>
            <label for 'type'><b>Type:</b></label><select name='type' class='questionnable'>
                <option <?php echo ($_SESSION['type'] == 'open') ? "selected" : '' ;?> value="open">Open (Input Box)</option>
                <option <?php echo ($_SESSION['type'] == 'choice') ? "selected" : '' ;?> value="choice">Choice</option>
                <option <?php echo ($_SESSION['type'] == 'multichoice') ? "selected" : '' ;?> value="multichoice">Multiple Choice</option>
                <option <?php echo ($_SESSION['type'] == 'veracity') ? "selected" : '' ;?> value="veracity">True or False</option>
                <option <?php echo ($_SESSION['type'] == 'caption') ? "selected" : '' ;?> value="caption">Caption</option>
            </select><br>
            <label for 'subject'><b>Subject:</b></label> <select name='subject' class='questionnable' id='subjectsel'>
                <option <?php echo ($_SESSION['subject'] == "Bioquímica II") ? "selected" : '' ;?> value="Bioquímica II" >Bioquímica II</option>
                <option <?php echo ($_SESSION['subject'] == "Biologia Molecular e Celular II") ? "selected" : '' ;?> value="Biologia Molecular e Celular II" >Biologia Molecular e Celular II</option>
                <option <?php echo ($_SESSION['subject'] == "Anatomia Humana II(Teórica)") ? "selected" : '' ;?> value="Anatomia Humana II(Teórica)" >Anatomia Humana II(Teórica)</option>
                <option <?php echo ($_SESSION['subject'] == "Anatomia Humana II(Prática)") ? "selected" : '' ;?> value="Anatomia Humana II(Prática)" >Anatomia Humana II(Prática)</option>
                <option <?php echo ($_SESSION['subject'] == "Introdução à Saúde Comunitária") ? "selected" : '' ;?> value="Introdução à Saúde Comunitária" >Introdução à Saúde Comunitária</option>
                <option <?php echo ($_SESSION['subject'] == "Bioestatística") ? "selected" : '' ;?> value="Bioestatística" >Bioestatística</option>
                <option <?php echo ($_SESSION['subject'] == "Inglês II") ? "selected" : '' ;?> value="Inglês II" >Inglês II</option>
                </select> <br>
            <label for 'level'><b>Level:</b></label><select name='level' class='questionnable' id='levelsel'>
                <option <?php echo ($_SESSION['level'] == '1') ? "selected" : '' ;?> value="1" >1º Teste Teórico</option>
                <option <?php echo ($_SESSION['level'] == '2') ? "selected" : '' ;?> value="2" >2º Teste Teórico</option>
                <option <?php echo ($_SESSION['level'] == '3') ? "selected" : '' ;?> value="3">Exame</option>
                </select><br>
            <br></div>
            <button id="btnSubmit" form='question' type='submit'>SUBMIT</button>
        </form>
        <?php $stats = mysqli_fetch_assoc($conn->query("SELECT * FROM statistics"));?><br>
        
    <table class="tgt">
    <thead>
      <tr>
        <th class="tgt-0lax"><b>Questions Created</b></th>
        <th class="tgt-0lax"><b>Tests Taken</b></th>
        <th class="tgt-0lax"><b>Journeys Taken</b></th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td class="tgt-0lax"><?php echo $stats['questions']?></td>
        <td class="tgt-0lax"><?php echo $stats['quizzes_done']?></td>
        <td class="tgt-0lax"><?php echo $stats['journeys_num']?></td>
      </tr>
    </tbody>
    </table><br>
    <span class="datapagebutton"><button id="previousData" class="datapagebutton">Previous</button> | <span id="pagenumdata">0</span> | <button id="nextData" class="datapagebutton">Next</button></span>
        <div id="quizlings">
        <?php
        $table = mysqli_fetch_assoc($conn->query("SELECT * FROM quiz"));
        $bar = $conn->query("SELECT * FROM quiz ORDER BY level DESC");
        $content = 0;
        if (mysqli_num_rows($conn->query("SELECT * FROM quiz")) > 0) {
          while ($result = mysqli_fetch_assoc($bar)) {
              ++$content;
              $answered = explode("|",$result['answer']);
              echo "<p align=left><b>".$result['question']."</b><br>R: ".implode("<br>",$answered)."</p>";
              if ($content == 10) { echo "$!";$content = 0; };
          };
    };
        ?></div>
    </div>

    <!--<div id="like_button_container"></div>-->
    <script src="https://unpkg.com/react@17/umd/react.development.js" crossorigin></script>
    <script src="https://unpkg.com/react-dom@17/umd/react-dom.development.js" crossorigin></script>

    <!--<script src="test.js"></script>-->
</body>

</html>