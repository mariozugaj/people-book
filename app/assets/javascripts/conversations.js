var App = App || {};

App.Conversations = (function () {

  var init = function () {
    _scrollToBottom();
    _submitMessageForm();
    _getUnreadCount();
  };

  var _scrollToBottom = function () {
    var $messagesContainer = $('.messages');
    if ($messagesContainer.length > 0) {
      $messagesContainer.scrollTop($messagesContainer[0].scrollHeight);
    }
  };

  var _submitMessageForm = function () {
    var messageSubmitButton = document.getElementById('message_submit');
    if (document.body.contains(messageSubmitButton)) {
      messageSubmitButton.addEventListener('click', function (e) {
        e.preventDefault();
        this.parentElement.submit();
        this.parentElement.reset();
        this.previousElementSibling.focus();
      });
    }
  };

  var conversationCounter = function () {
    return $("[data-behavior='unread-msg-count']");
  };

  var updateUnreadCount = function (unreadCount) {
    conversationCounter().text(unreadCount);
    if (unreadCount > 0) {
      conversationCounter().addClass('red');
    } else {
      conversationCounter().removeClass('red');
    }
  };

  var _getUnreadCount = function () {
    if (conversationCounter().length > 0) {
      return $.ajax({
        url: '/conversations/unread_count',
        dataType: 'JSON',
        method: 'GET',
        success: updateUnreadCount,
      });
    }
  };

  return {
    init: init,
  };

})();

document.addEventListener('DOMContentLoaded', function () {
  return App.Conversations.init();
});
