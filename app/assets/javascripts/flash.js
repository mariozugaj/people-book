var PeopleBook = PeopleBook || {};

PeopleBook.FlashModule = (function () {

  var init = function () {
    _flashListener();
    _stickFlashToTop();
  };

  var _flashListener = function () {
    var flashTimeout;

    clearTimeout(flashTimeout);

    $('#flash').show();

    flashTimeout = setTimeout(function () {
      $('#flash').slideUp(250);
    }, 4000);
  };

  var _stickFlashToTop = function () {
    $(window).scroll(function () {
      $('#flash').css('top', Math.max(54, 54 - $(this).scrollTop()));
    });
  };

  return {
    init: init,
  };
})();
