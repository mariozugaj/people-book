var PeopleBook = PeopleBook || {};

PeopleBook.ImagesModule = (function () {

  var init = function () {
    _setCommentsSize();
  };

  var _setCommentsSize = function () {
    var imageContainer = document.querySelector('[data-behavior="image-container"]');
    if (document.body.contains(imageContainer)) {
      var commentsContainer = document.querySelector('.image_show_card');
      var imageContainerHeight = imageContainer.offsetHeight;
      commentsContainer.style.maxHeight = imageContainerHeight + 'px';
    }
  };

  return {
    init: init,
  };

})();
