var App = App || {};

App.Dropdowns = (function () {

  var init = function () {
    _dropdownListeners();
  };

  var _dropdownListeners = function () {
    $('.hover.dropdown')
      .dropdown({
      on: 'hover',
    });

    $('.ui.dropdown:not(.hover.dropdown)')
      .dropdown();
  };

  return {
    init: init,
  };
})();

document.addEventListener('DOMContentLoaded', function () {
  return App.Dropdowns.init();
});
