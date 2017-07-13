var PeopleBook = PeopleBook || {};

PeopleBook.DropdownsModule = (function () {

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
