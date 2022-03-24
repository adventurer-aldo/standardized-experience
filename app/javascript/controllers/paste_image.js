if (document.getElementById('image') != null) {
    var item = document.getElementById('image');
    window.addEventListener('paste', e => {
        item.files = e.clipboardData.files;
        var img = new Image();
        var bg = Array.from(e.clipboardData.items).find(x => /^image\//.test(x.type));
        var blob = bg.getAsFile();
        img.src = URL.createObjectURL(blob);
        img.onload = function(){
        document.getElementById('haer').style.backgroundImage = "url('" + img.src + "')"
        }
    });
};

if (document.getElementById('question') != null) {
    document.getElementById('question').focus();
 }