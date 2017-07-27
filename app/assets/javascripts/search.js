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
          url: '/autocomplete/?q={query}',
        },
        fields: {
          categories: 'results',
          categoryName: 'name',
          categoryResults: 'results',
          title: 'title',
          url: 'url',
          image: 'image',
          description: 'description',
          action: 'action',
          actionText: 'text',
          actionUrl: 'url',
        },
        minCharacters: 3,
        maxResults: 3,
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
