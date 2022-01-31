<?php
    require "connect.php";

    $stats = pg_fetch_assoc(pg_query($conn,"SELECT * FROM statistics"));
    $journeys_num = ++$stats['journeys_num'];
    pg_query($conn,"UPDATE statistics SET active_journey_id=$journeys_num");
    pg_query($conn,"UPDATE statistics SET journeys_num=$journeys_num");
    $available_quests = pg_query($conn,"SELECT DISTINCT subject FROM quiz ORDER BY rand()");

    if (pg_num_rows($available_quests) > 0 ) {
        while ($subjact = pg_fetch_assoc($available_quests)) {
            pg_query($conn,"INSERT INTO journeys (subject,id,grade_dissertation) VALUES ('".$subjact['subject']."',$journeys_num,".rand(0,20).")");
        };
    };


?>