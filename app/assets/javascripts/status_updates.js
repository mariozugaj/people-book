var App = App || {};

App.StatusUpdates = (function () {
  var init = function () {
    _statusUpdatetFocusListener();
    _cancelStatusUpdateLinkListener();
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

  return {
    init: init,
  };

})();

document.addEventListener('DOMContentLoaded', function () {
  return App.StatusUpdates.init();
});
