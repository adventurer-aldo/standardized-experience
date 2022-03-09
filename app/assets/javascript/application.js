$(document).ready(function(){
    // Set the date we're counting down to
    var ehhh = new Date();
    var countDownDate = new Date(ehhh.getTime() + 0.175*60000);

// Update the count down every 1 second
    var x = setInterval(function() {

  // Get today's date and time
  var now = new Date().getTime();

  // Find the distance between now and the count down date
  var distance = countDownDate - now;

  // Time calculations for days, hours, minutes and seconds
  // var days = Math.floor(distance / (1000 * 60 * 60 * 24));
  // var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
  var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
  var seconds = Math.floor((distance % (1000 * 60)) / 1000);

  // Display the result in the element with id="demo"
  document.getElementById("timer").innerHTML = minutes + "m " + seconds + "s ";

  // If the count down is finished, write some text
  if (distance < 0) {
    clearInterval(x);
    document.getElementById("timer").innerHTML = "Time's up!";
    document.getElementById("quiz").submit();
  } else if (minutes == 1 && seconds == 30) {
    var primeiro = document.getElementById('test1');
    if (primeiro != null) {document.getElementById('test1').src='audio/rushtest1.mp3'; };

    var segundo = document.getElementById('test2');
    if (segundo != null) {document.getElementById('test2').src='audio/rushtest2.mp3'; };

    var terceiro = document.getElementById('exam');
    if (terceiro != null) {document.getElementById('exam').src='audio/rushexam.mp3'; };

    var quarto = document.getElementById('examrec');
    if (quarto != null) {document.getElementById('examrec').src='audio/rushexam.mp3'; };

    document.getElementById('theme').load();
  };
}, 1000);
});

$(document).ready(function(){
  $('#quiz').on('submit', function(e) {
    e.preventDefault();
    document.getElementById("quiz").submit();
  });
});