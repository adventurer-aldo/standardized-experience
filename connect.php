<?php
// Create connection
$conn = pg_connect("host=ec2-52-208-145-55.eu-west-1.compute.amazonaws.com user=jxjrhhnsbrdceq password=26ef405f573a3c924900cf77a5fa8dc7d6a9e73499724dd79ab8bdd0bd475f93 dbname=d3jdf665veionf");

pg_query($conn,"INSERT INTO statistics VALUES (91, 81, 81, 8, 8, 0, -1)");

pg_query($conn,"ALTER TABLE quiz
ADD UNIQUE KEY question ('question') USING HASH");

pg_query($conn,"ALTER TABLE statistics
ADD UNIQUE KEY 'users_num' ('users_num');");
// Check connection
// <?php $aka = $conn->query("SELECT * FROM subject");$nume = pg_fetch_assoc($aka); echo "<li class='dashitem'>".implode("|",$nume)."</li>";
?>