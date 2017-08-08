var App = App || {};

App.Images = (function () {

  var init = function () {
    _lazyImageLoad();
  };

  var setCommentsSize = function () {
    var imageContainer = document.querySelector('[data-behavior="image-container"]');
    if (document.body.contains(imageContainer)) {
      var commentsContainer = document.querySelector('.image_show_card');
      var imageContainerHeight = imageContainer.offsetHeight;
      commentsContainer.style.maxHeight = imageContainerHeight + 'px';
    }
  };

  var _lazyImageLoad = function () {
    $('.lazy_image .image img')
      .visibility({
        type       : 'image',
        transition : 'fade in',
        duration   : 1000,
    });
  };

  return {
    init: init,
    setCommentsSize: setCommentsSize,
  };

})();

document.addEventListener('DOMContentLoaded', function () {
  return App.Images.init();
});
