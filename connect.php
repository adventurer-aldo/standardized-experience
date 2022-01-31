<?php
    // Create connection
    $conn = pg_connect("host=ec2-52-208-145-55.eu-west-1.compute.amazonaws.com user=jxjrhhnsbrdceq password=26ef405f573a3c924900cf77a5fa8dc7d6a9e73499724dd79ab8bdd0bd475f93 dbname=d3jdf665veionf");

    pg_query($conn,"CREATE TABLE quizzes (
        name text NOT NULL,
        surname text NOT NULL,
        subject text NOT NULL,
        id int NOT NULL,
        journey text DEFAULT NULL,
        question text NOT NULL,
        answer text NOT NULL,
        time_left int NOT NULL,
        date int NOT NULL
      )");

    pg_query($conn,"CREATE TABLE statistics (
        questions int NOT NULL,
        quizzes_done int NOT NULL,
        last_quiz_id int NOT NULL,
        journeys_num int NOT NULL,
        active_journey_id int NOT NULL,
        current_journey_progress int NOT NULL DEFAULT 0,
        users_num int NOT NULL
      )");
    // Check connection
    // <?php $aka = $conn->query("SELECT * FROM subject");$nume = pg_fetch_assoc($aka); echo "<li class='dashitem'>".implode("|",$nume)."</li>";
?>