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
      if (!element.id) throw 'Autoplay elements will need an ID attribute'
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