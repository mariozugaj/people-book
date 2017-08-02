var PeopleBook = PeopleBook || {};

PeopleBook.StatusUpdatesModule = (function () {

  var init = function () {
    _statusUpdatetFocusListener();
    _cancelStatusUpdateLinkListener();
    _statusUpdateImageLoad();
  };

  var _statusUpdatetFocusListener = function () {
    $("[data-behavior='su-form-link']").on('focus', function (e) {
      var $actions = $(this).parent().next();
      $actions.slideDown('fast');
    });
  };

  var _cancelStatusUpdateLinkListener = function () {
    $("[data-behavior='su-form-cancel-link']").on('click', function (e) {
      e.preventDefault();
      var $actions = $(this).parent();
      $actions.slideUp('fast');
    });
  };

  var _statusUpdateImageLoad = function () {
    $('.lazy_image .image img')
      .visibility({
        type       : 'image',
        transition : 'fade in',
        duration   : 1000,
    });
  };

  return {
    init: init,
  };

})();
