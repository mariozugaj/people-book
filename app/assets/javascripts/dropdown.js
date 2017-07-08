$(document).on('turbolinks:load', function () {

  $('#user_menu__dropdown').dropdown({
    on: 'hover',
  });

  $('.ui.dropdown:not(#user_menu__dropdown)').dropdown();
});
