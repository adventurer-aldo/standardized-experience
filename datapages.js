var datapage = 1;
var datapaged = "s";

window.onload = function() {
    datapaged = document.getElementById("quizlings").innerHTML.split("$!")
    document.getElementById("quizlings").innerHTML = datapaged[datapage-1];
    document.getElementById("pagenumdata").innerHTML = datapage;
};

$(document).ready(function() {
    document.getElementById("nextData").onclick = function() {
        datapage += 1;
        if (datapage == (datapaged.length + 1)) {
            datapage = 1
        };
        document.getElementById("quizlings").innerHTML = datapaged[datapage-1];
        document.getElementById("pagenumdata").innerHTML = datapage;
    };
});

$(document).ready(function() {
    document.getElementById("previousData").onclick = function() {
        datapage -= 1;
        if (datapage == 0) {
            datapage = datapaged.length
        };
        document.getElementById("quizlings").innerHTML = datapaged[datapage-1];
        document.getElementById("pagenumdata").innerHTML = datapage;
    };
});