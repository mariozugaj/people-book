App.whoIsOnline = App.cable.subscriptions.create({
  channel: 'AppearancesChannel',
}, {
  connected: function() {},
  disconnected: function() {},
  received: function(data) {
    var user;
    user = $('.user-' + data['user_id']);
    user.toggleClass('green', data['online']);
  }
});
