<?php $ara = pg_query($conn,"SELECT DISTINCT subject FROM quiz ORDER BY ".rand()." LIMIT 1"); $_SESSION['subjecto'] = pg_fetch_assoc($ara);?>
<div id="return"><a class="home" href="experience.php"><i class="fas fa-home"></i></a><a class="data" href="data.php"><i class="fas fa-file"></i></a><a class="reload" href="practice.php"><i class="fas fa-sync-alt"></i></a><a class="about" href="about.php"><i class="fas fa-question"></i></a></div>