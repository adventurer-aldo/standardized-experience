<?php
    // Create connection
    $conn = pg_connect("host=ec2-52-208-145-55.eu-west-1.compute.amazonaws.com user=jxjrhhnsbrdceq password=26ef405f573a3c924900cf77a5fa8dc7d6a9e73499724dd79ab8bdd0bd475f93 dbname=d3jdf665veionf");

            pg_query($conn,"INSERT INTO journeys VALUES
            ('Nenhuma', 0, 2, 5, 0, 16, 0, 0),
            ('Bioquímica II', 7, NULL, NULL, NULL, NULL, NULL, NULL),
            ('Biologia Molecular e Celular II', 7, NULL, NULL, NULL, NULL, NULL, NULL),
            ('Biologia Molecular e Celular II', 8, NULL, NULL, NULL, 9, NULL, NULL),
            ('Bioquímica II', 8, NULL, NULL, NULL, 12, NULL, NULL)");
    // Check connection
    // <?php $aka = $conn->query("SELECT * FROM subject");$nume = pg_fetch_assoc($aka); echo "<li class='dashitem'>".implode("|",$nume)."</li>";
?>