$(document).ready(function(){
    $('input[type=checkbox].singlecheck').on('change', function (e) {
        if ($("input[type=checkbox][name="+this.name+"]:checked").length > 1) {
            $(this).prop('checked', false);
        }
    });
}); 

$(document).ready(function(){
    // Set the date we're counting down to
    var ehhh = new Date();
    var countDownDate = new Date(ehhh.getTime() + 5*60000);

// Update the count down every 1 second
    var x = setInterval(function() {

  // Get today's date and time
  var now = new Date().getTime();

  // Find the distance between now and the count down date
  var distance = countDownDate - now;

  // Time calculations for days, hours, minutes and seconds
  var days = Math.floor(distance / (1000 * 60 * 60 * 24));
  var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
  var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
  var seconds = Math.floor((distance % (1000 * 60)) / 1000);

  // Display the result in the element with id="demo"
  document.getElementById("demo").innerHTML = minutes + "m " + seconds + "s ";

  // If the count down is finished, write some text
  if (distance < 0) {
    clearInterval(x);
    document.getElementById("demo").innerHTML = "Time's up!";
    document.getElementById("quiz").submit();
  };
}, 1000);
});