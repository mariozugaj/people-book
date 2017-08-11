App.ConversationsUpdate = App.cable.subscriptions.create('ConversationsChannel', {
  connected: function () {
    // Called when the subscription is ready for use on the server
  },

  disconnected: function () {
    // Called when the subscription has been terminated by the server
  },

  received: function (data) {
    if (($('#messages').length > 0) && (data.conversation_id === $('#messages').data('conversation-id'))) {
      var $messages = $('.messages');
      $('#messages').append(data.message);
      $messages.scrollTop($messages[0].scrollHeight);
    } else {
      App.Conversations.updateUnreadCount(data.unread_count);
    }
  },
});
