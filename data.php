<?php require "connect.php"?>

<!DOCTYPE html>
<html lang="en">

<head>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="styled.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Neonderthaw&family=Yanone+Kaffeesatz&family=Nunito:wght@300&display=swap" rel="stylesheet"> 
    <script src="https://kit.fontawesome.com/f22718211c.js" crossorigin="anonymous"></script>
</head>

<body>
    <div id="page">
        <div id="logos"></div><p id="logotext">STANDARDIZED-EXPERIENCE</p>
        <ul id="lisuto">
            <li class="dashitem"><a href="experience.php" class="dashitm">Home</a></li>
            <li class="dashitem"><a href="data.php" class="dashitm">Data</a></li>
            <li class="dashitem"><a href="practice.php" class="dashitm">Practice</a></li>
            <li class="dashitemr"><a href="about.php" class="dashitm">About</a></li>
        </ul>
        <form action='new_question.php' method='get' id='question'>
            <label for 'question'><b>Question:</b></label><input type=text name='question' class='questionnable'><br>
            <label for 'answer'><b>Answer:</b></label><input type=text name='answer' class='questionnable'><br>
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
            <br>
            <button id="submit" form='question' type='submit'>SUBMIT</button>
        </form>
        <?php
        $table = mysqli_fetch_assoc($conn->query("SELECT * FROM quiz"));
        $bar = $conn->query("SELECT * FROM quiz ORDER BY subject DESC");
        if (mysqli_num_rows($conn->query("SELECT * FROM quiz")) > 0) {
        while ($result = mysqli_fetch_assoc($bar)) {
            echo "<p><b>".$result['question']."</b><br>".$result['answer']."</p>";
        };
    };
        ?>
    </div>

    <!--<div id="like_button_container"></div>-->
    <script src="https://unpkg.com/react@17/umd/react.development.js" crossorigin></script>
    <script src="https://unpkg.com/react-dom@17/umd/react-dom.development.js" crossorigin></script>

    <!--<script src="test.js"></script>-->
</body>

</html>