<?php $_SESSION['subjecto'] = pg_fetch_assoc(pg_query($conn,'SELECT DISTINCT subject FROM quiz  OFFSET random() * (SELECT COUNT (*) FROM  LIMIT 1'));?>
<div id="return"><a class="home" href="experience.php"><i class="fas fa-home"></i></a><a class="data" href="data.php"><i class="fas fa-file"></i></a><a class="reload" href="practice.php"><i class="fas fa-sync-alt"></i></a><a class="about" href="about.php"><i class="fas fa-question"></i></a></div>