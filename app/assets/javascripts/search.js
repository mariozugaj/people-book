var PeopleBook = PeopleBook || {};

PeopleBook.SearchModule = (function () {

  var init = function () {
    _searchListener();
    _searchValidator();
  };

  var _searchListener = function () {
    $('.ui.category.search')
      .search({
        type: 'category',
        selector: {
          prompt: '.search.input',
        },
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

  var _searchValidator = function () {
    $('.ui.category.search')
      .form({
        inline: true,
        fields: {
          q: 'empty',
        },
      });
  };

  return {
    init: init,
  };

})();
