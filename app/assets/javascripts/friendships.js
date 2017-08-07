var App = App || {};

App.Friendships = (function () {

  var init = function () {
    _friendshipButtonListener();
  };

  var _friendshipButtonListener = function () {
    $('.friendship_button').on('mouseenter mouseleave', function (e) {
      var $container = $(this).find('.unfriend');
      var $icon = $container.children('i');
      var $buttonText = $container.children('span');

      if (e.type == 'mouseenter') {
        $icon.removeClass('checkmark');
        $icon.addClass('remove user');
        $buttonText.text('Unfriend');
      } else if (e.type == 'mouseleave') {
        $icon.removeClass('remove user');
        $icon.addClass('checkmark');
        $buttonText.text('Friends');
      }
    });
  };

  return {
    init: init,
  };
})();

document.addEventListener('DOMContentLoaded', function () {
  return App.Friendships.init();
});
