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

;(function () {
  var each = Array.prototype.forEach
  var autoplayIds = []

  document.addEventListener('turbo:before-cache', function () {
    var autoplayElements = document.querySelectorAll('[autoplay]')
    each.call(autoplayElements, function (element) {
      if (!element.id) throw 'Autoplay elements need an ID attribute'
      autoplayIds.push(element.id)
      element.removeAttribute('autoplay')
    })
  })

  document.addEventListener('turbo:before-render', function (event) {
    autoplayIds = autoplayIds.reduce(function (ids, id) {
      var autoplay = event.data.newBody.querySelector('#' + id)
      if (autoplay) autoplay.setAttribute('autoplay', true)
      else ids.push(id)
      return ids
    }, [])
  })
})()