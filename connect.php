<?php
    $servername = "localhost";
    $username = "asher";
    $password = "usher";
    $database = "standardized_experience";

    // Create connection
    $conn = mysqli_connect($servername, $username, $password, $database);

    // Check connection
    if (!$conn) {
        die("Connection failed: " . mysqli_connect_error());
    }
    // <?php $aka = $conn->query("SELECT * FROM subject");$nume = mysqli_fetch_assoc($aka); echo "<li class='dashitem'>".implode("|",$nume)."</li>";
?>