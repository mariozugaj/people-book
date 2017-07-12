$(document).on('turbolinks:load', function () {
  $(document).on('mouseenter mouseleave', '.friendship_button', function (e) {
    var container = $(this).find('.unfriend');
    var friends = "<i class='checkmark icon'></i><span>Friends</span>";
    var unfriend = "<i class='remove user icon'></i><span>Unfriend</span>";
    container.html(e.type == 'mouseenter' ? unfriend : friends);
  });

  $('.raised.card .image, .ui.small.images .image').dimmer({
    on: 'hover',
  });
});
