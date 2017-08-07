// Form validation rules
$.fn.form.settings.rules.emailCheck = function (value, boolean) {

  $.ajax({
    type: 'GET',
    url: '/check_email',
    async: false,
    data: {
      email: value,
    },
    success: function (data) {
      result = (data == boolean)
    },
  });
  return result;
};

var App = App || {};

App.FormValidations = (function () {

  var init = function () {
    _validateRegistration();
    _validateLogin();
    _validateUpdate();
  };

  var _validateRegistration = function () {
    $("form[action='/users']")
      .form({
        on: 'blur',
        inline: true,
        revalidate: false,
        fields: {
          first_name: {
            identifier: 'user[name]',
            rules: [{
              type: 'empty',
              prompt: 'Please enter your full name',
            }]
          },
          email: {
            identifier: 'user[email]',
            rules: [{
              type: 'empty',
              prompt: 'Please enter your email'
            }, {
              type: 'email',
              prompt: 'That email doesn\'t look right',
            }, {
              type: 'emailCheck[false]',
              prompt: 'Sorry, that email has been taken',
            }]
          },
          password: {
            identifier: 'user[password]',
            rules: [{
              type: 'empty',
              prompt: 'Please enter your password'
            }, {
              type: 'minLength[6]',
              prompt: 'Please enter a 6 characters minimum password',
            }]
          },
          checkbox: {
          identifier  : 'checkbox',
          rules: [
            {
              type   : 'checked',
              prompt : 'You have to agree to Terms and Conditions'
            }]
          }
        }
      });
  };

  var _validateLogin = function () {
    $('form#new_user')
      .form({
        on: 'blur',
        inline: true,
        revalidate: false,
        fields: {
          email: {
            identifier: 'user[email]',
            rules: [{
              type: 'empty',
              prompt: 'Please enter your email'
            }, {
              type: 'email',
              prompt: 'That email doesn\'t look right',
            }, {
              type: 'emailCheck[true]',
              prompt: 'Sorry, we can\'t find a user with that email',
            }]
          },
          password: {
            identifier: 'user[password]',
            rules: [{
              type: 'empty',
              prompt: 'Please enter your password'
            }]
          }
        }
      });
  };

  var _validateUpdate = function () {
    $('form#edit_user')
      .form({
        on: 'blur',
        inline: true,
        revalidate: false,
        fields: {
          first_name: {
            identifier: 'user[name]',
            rules: [{
              type: 'empty',
              prompt: 'Please enter your full name',
            }]
          },
          email: {
            identifier: 'user[email]',
            rules: [{
              type: 'empty',
              prompt: 'Please enter your email'
            }, {
              type: 'email',
              prompt: 'That email doesn\'t look right',
            }]
          },
          current_password: {
            identifier: 'user[current_password]',
            rules: [{
              type: 'empty',
              prompt: 'Please enter your password'
            }, {
              type: 'minLength[6]',
              prompt: 'Please enter a 6 characters minimum password',
            }]
          }
        }
      });
  };

  return {
    init: init,
  };
})();

document.addEventListener('DOMContentLoaded', function () {
  return App.FormValidations.init();
});
