$(document).on('turbolinks:load', function () {

  var flashTimeout;
  clearTimeout(flashTimeout);
  $('#flash').show();
  flashTimeout = setTimeout(function () {
    $('#flash').slideUp(250);
  }, 6000);
});
