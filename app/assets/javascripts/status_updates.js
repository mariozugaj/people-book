$(document).on('turbolinks:load', function () {
  var textarea = document.getElementById('status_update__textarea');
  var actions = textarea.parentElement.nextElementSibling;

  function showFormActions(e) {
    textarea.rows = '4';
    $(actions).slideDown('fast');
  };

  function hideFormActions(e) {
    $(actions).slideUp('fast', function () {
      textarea.rows = '1';
    });
  };

  textarea.addEventListener('focus', showFormActions, false);
  textarea.addEventListener('blur', hideFormActions, false);
});
