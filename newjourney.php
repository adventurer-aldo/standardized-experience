<?php
    require "connect.php";

    $stats = mysqli_fetch_assoc($conn->query("SELECT * FROM statistics"));
    $journeys_num = ++$stats['journeys_num'];
    $conn->query("UPDATE statistics SET active_journey_id=$journeys_num");
    $conn->query("UPDATE statistics SET journeys_num=$journeys_num");
    $conn->query("UPDATE statistics SET current_journey_progress=0");
    $available_quests = $conn->query("SELECT DISTINCT subject FROM quiz ORDER BY rand()");

    if (mysqli_num_rows($available_quests) > 0 ) {
        while ($subjact = mysqli_fetch_assoc($available_quests)) {
            $conn->query("INSERT INTO journeys (subject,id,grade_dissertation) VALUES ('".$subjact['subject']."',$journeys_num,".rand(0,20).")");
        };
    };
    header("Location: experience.php");

?>