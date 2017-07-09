$(document).on('turbolinks:load', function () {

  $('.hover.dropdown').dropdown({
    on: 'hover',
  });

  $('.ui.dropdown:not(.hover.dropdown)').dropdown();
});
