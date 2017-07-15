var PeopleBook = PeopleBook || {};

PeopleBook.SearchModule = (function () {

  var init = function () {
    _searchListener();
  };

  var _searchListener = function () {
    $('.ui.category.search')
      .search({
        type: 'category',
        apiSettings: {
          url: '/search/?q={query}',
        },
        fields: {
          categories: 'results',
          categoryName: 'name',
          categoryResults: 'results',
          title: 'name',
          url: 'url',
          image: 'avatar',
          description: 'description',
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
