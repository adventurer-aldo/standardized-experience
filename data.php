<?php require "connect.php";
session_start();?>

<!DOCTYPE html>
<html lang="en">

<?php require "head.php"?>

<body>
    <div id="page">
        <?php require 'head_branch.php';echo "<p id='warning'>".$_SESSION['error']."</p>"?>
        <form action='new_question.php' method='get' id='question' autocomplete='off'><div class='leftal'>
            <label for 'question'><b>Question:</b></label><input type=text name='question' class='questionnable' required><br>
            <label for 'answer'><b>Answer:</b></label><input type=text name='answer' class='questionnable' required><br>
            <label for 'choices'><b>Choices:</b><input type=text name='choices' class='questionnable' value='NULL' required><br>
            <label for 'type'><b>Type:</b></label><select name='type' class='questionnable'>
                <option value="open">Open (Input Box)</option>
                <option value="choice">Choice</option>
                <option value="multichoice">Multiple Choice</option>
                <option value="veracity">True or False</option>
            </select><br>
            <label for 'subject'><b>Subject:</b></label> <select name='subject' class='questionnable'>
                <option value="Bioquímica II">Bioquímica II</option>
                <option value="Biologia Molecular e Celular II">Biologia Molecular e Celular II</option>
                <option value="Anatomia Humana II(Teórica)">Anatomia Humana II(Teórica)</option>
                <option value="Anatomia Humana II(Prática)">Anatomia Humana II(Prática)</option>
                <option value="Introdução à Saúde Comunitária">Introdução à Saúde Comunitária</option>
                <option value="Bioestatística">Bioestatística</option>
                </select> <br>
            <label for 'level'><b>Level:</b></label><select name='level' class='questionnable'>
                <option value="1">1º Teste Teórico</option>
                <option value="2">2º Teste Teórico</option>
                <option value="3">Exame</option>
                </select><br>
            <br></div>
            <button id="submit" form='question' type='submit'>SUBMIT</button>
        </form>
        <div style='max-height: 500px;overflow: scroll;'>
        <?php
        $table = mysqli_fetch_assoc($conn->query("SELECT * FROM quiz"));
        $bar = $conn->query("SELECT * FROM quiz ORDER BY subject DESC");
        if (mysqli_num_rows($conn->query("SELECT * FROM quiz")) > 0) {
        while ($result = mysqli_fetch_assoc($bar)) {
            $answered = explode("|",$result['answer']);
            echo "<p align=left><b>".$result['question']."</b><br>R: ".implode("&",$answered)."</p>";
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