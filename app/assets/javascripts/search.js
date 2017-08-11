var App = App || {};

App.Search = (function () {

  var init = function () {
    _globalAutocomplete();
    _searchValidator();
    _usersAutocomplete();
  };

  var _globalAutocomplete = function () {
    $('.ui.category.search')
      .search({
        type: 'category',
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
        minCharacters: 1,
        maxResults: 4,
        showNoResults: true,
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

  var _usersAutocomplete = function () {
    $('.ui.search.users')
      .search({
        apiSettings: {
          url: '/autocomplete/friends?q={query}',
        },
        fields: {
          title: 'title',
          url: 'url',
          image: 'image',
          url: 'url',
        },
        showNoResults: true,
      });
  };

  return {
    init: init,
  };

})();

document.addEventListener('DOMContentLoaded', function () {
  return App.Search.init();
});
