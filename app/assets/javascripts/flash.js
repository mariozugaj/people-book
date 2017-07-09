$(document).on('turbolinks:load', function () {

  $(window).scroll(function () {
    $('#flash').css('top', Math.max(0, 54 - $(this).scrollTop()));
  });

  var flashTimeout;
  clearTimeout(flashTimeout);
  $('#flash').show();
  flashTimeout = setTimeout(function () {
    $('#flash').slideUp(250);
  }, 4000);
});
