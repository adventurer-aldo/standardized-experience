if (document.getElementById('question_image')) {
    var item = document.getElementById('question_image');
    window.addEventListener('paste', e => {
        item.files = e.clipboardData.files;
        var img = new Image();
        var bg = Array.from(e.clipboardData.items).find(x => /^image\//.test(x.type));
        
        if (bg) {
            var blob = bg.getAsFile();
            img.src = URL.createObjectURL(blob);
        } else {
            console.log("No image was pasted!")
        }
    });
};

Object.defineProperty(String.prototype, 'capitalize', {
  value: function() {
    return this.charAt(0).toUpperCase() + this.slice(1);
  },
  enumerable: false
});