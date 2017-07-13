var PeopleBook = PeopleBook || {};

PeopleBook.FriendshipsModule = (function () {

  var init = function () {
    _friendshipButtonListener();
    _friendCardDimmer();
  };

  var _friendshipButtonListener = function () {
    $('.friendship_button').on('mouseenter mouseleave', function (e) {
      var container = $(this).find('.unfriend');
      var friends = "<i class='checkmark icon'></i><span>Friends</span>";
      var unfriend = "<i class='remove user icon'></i><span>Unfriend</span>";
      container.html(e.type == 'mouseenter' ? unfriend : friends);
    });
  };

  var _friendCardDimmer = function () {
    $('.raised.card .image, .ui.small.images .image').dimmer({
      on: 'hover',
    });
  };

  return {
    init: init,
  };
})();
