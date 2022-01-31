<?php
    // Create connection
    $conn = pg_connect("host=ec2-52-208-145-55.eu-west-1.compute.amazonaws.com user=jxjrhhnsbrdceq password=26ef405f573a3c924900cf77a5fa8dc7d6a9e73499724dd79ab8bdd0bd475f93 dbname=d3jdf665veionf");

            pg_query($conn,"CREATE TABLE journeys (subject text DEFAULT 'Nenhuma',id int DEFAULT NULL,grade_1 int DEFAULT NULL,grade_2 int DEFAULT NULL,grade_reposition int DEFAULT NULL,grade_dissertation int DEFAULT NULL,exam int DEFAULT NULL,exam_reposition int DEFAULT NULL)");
    // Check connection
    // <?php $aka = $conn->query("SELECT * FROM subject");$nume = pg_fetch_assoc($aka); echo "<li class='dashitem'>".implode("|",$nume)."</li>";
?>