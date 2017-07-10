$(document).on('turbolinks:load', function () {
  var textarea = document.getElementById('status_update__textarea');

  function showFormActions() {
    textarea.rows = '4';
    $(actions).slideDown('fast');
  };

  function hideFormActions() {
    $(actions).slideUp('fast', function () {
      textarea.rows = '1';
    });
  };

  if (textarea != null) {
    var actions = textarea.parentElement.nextElementSibling;
    textarea.addEventListener('focus', showFormActions, false);
    textarea.addEventListener('blur', hideFormActions, false);
  }
});
