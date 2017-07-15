var PeopleBook = PeopleBook || {};

PeopleBook.SearchModule = (function () {

  var init = function () {
    _searchListener();
  };

  var _searchListener = function () {
    $('.ui.search')
      .search({
        apiSettings: {
          url: '/search/?q={query}',
        },
        fields: {
          results: 'people',
          title: 'name',
          url: 'url',
          image: 'avatar',
          description: 'hometown',
          action: 'action',
          actionText: 'text',
          actionUrl: 'url',
        },
        minCharacters: 1,
      });
  };

  return {
    init: init,
  };

})();
