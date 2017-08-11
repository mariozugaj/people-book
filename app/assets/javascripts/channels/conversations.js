App.conversations = App.cable.subscriptions.create('ConversationsChannel', {
  collection: function () {
    return $("[data-channel='messages']");
  },

  connected: function () {
    return setTimeout((function (_this) {
      return function () {
        _this.followCurrentConversation();
        return _this.installPageChangeCallback();
      };
    })(this), 1000);
  },

  received: function (data) {
    var $messages = $('.messages');
    this.collection().append(data.message);
    return $messages.scrollTop($messages[0].scrollHeight);
  },

  followCurrentConversation: function () {
    var conversationId;
    if (conversationId = this.collection().data('conversation-id')) {
      return this.perform('follow', {
        conversation_id: conversationId,
      });
    } else {
      return this.perform('unfollow');
    }
  },

  installPageChangeCallback: function () {
    if (!this.installedPageChangeCallback) {
      this.installedPageChangeCallback = true;
      return $(document).on('DOMContentLoaded', function () {
        return App.conversations.followCurrentConversation();
      });
    }
  },
});
