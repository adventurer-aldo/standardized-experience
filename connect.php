<?php
    // Create connection
    $conn = pg_connect("host=ec2-52-208-145-55.eu-west-1.compute.amazonaws.com, 
    user=jxjrhhnsbrdceq, 
    password=26ef405f573a3c924900cf77a5fa8dc7d6a9e73499724dd79ab8bdd0bd475f93, 
    dbname=d3jdf665veionf");

    $templine = '';
    $lines = file("standardized_experience.sql");

    foreach ($lines as $line) {
        if (substr($line, 0, 2) == '--' || $line == '')
        continue;

        $templine .= $line;
        if (substr(trim($line), -1, 1) == ';') { 
            pg_query($templine);
            $templine = '';
        };
    };
    // Check connection
    // <?php $aka = $conn->query("SELECT * FROM subject");$nume = pg_fetch_assoc($aka); echo "<li class='dashitem'>".implode("|",$nume)."</li>";
?>