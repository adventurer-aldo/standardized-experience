if (document.getElementById('image')) {
    var item = document.getElementById('image');
    window.addEventListener('paste', e => {
        item.files = e.clipboardData.files;
        var img = new Image();
        var bg = Array.from(e.clipboardData.items).find(x => /^image\//.test(x.type));
        
        if (bg) {
            var blob = bg.getAsFile();
            img.src = URL.createObjectURL(blob);
            img.onload = function(){
            document.getElementById('image').src =  img.src }
        } else {
            console.log("No image was pasted!")
        }
    });
};