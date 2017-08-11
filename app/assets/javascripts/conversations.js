var App = App || {};

App.Conversations = (function () {

  var init = function () {
    _scrollToBottom();
    _submitMessageForm();
    _markAsRead();
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

  var updateUnreadCount = function (unreadCount) {
    var $count = $("[data-behavior='unread-msg-count']");
    $count.text(unreadCount);
    if (unreadCount > 0) {
      $count.addClass('red');
    } else {
      $count.removeClass('red');
    }
  };

  var _markAsRead = function () {
    $(document).on('click', "[data-behavior='conversation-link']", function () {
      return $.ajax({
        url: '/conversations/' + $(this).data('id') + '/mark_as_read',
        dataType: 'JSON',
        method: 'POST',
      });
    });
  };

  var _getUnreadCount = function () {
    return $.ajax({
      url: '/conversations/unread_count',
      dataType: 'JSON',
      method: 'GET',
      success: updateUnreadCount,
    });
  };

  return {
    init: init,
    updateUnreadCount: updateUnreadCount,
  };

})();

document.addEventListener('DOMContentLoaded', function () {
  return App.Conversations.init();
});
