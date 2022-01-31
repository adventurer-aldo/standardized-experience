<div id="logos"></div><p id="logotext">STANDARDIZED-EXPERIENCE</p><form method='get' id='practicioner' action='practice.php'></form>
<?php $_SESSION['subjecto'] = pg_fetch_assoc(pg_query($conn,'SELECT DISTINCT subject FROM quiz ORDER BY rand() LIMIT 1'));?>
        <ul id="lisuto">
            <li class="dashitem"><a href="experience.php" class="dashitm">Home</a></li>
            <li class="dashitem"><a href="data.php" class="dashitm">Data</a></li>
            <li class="dashitem"><a href="practice.php" class="dashitm">Practice</a></li>
            <li class="dashitemr"><a href="about.php" class="dashitm">About</a></li>
        </ul>