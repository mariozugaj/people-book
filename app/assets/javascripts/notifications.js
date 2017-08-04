var Notifications,
  bind = function (fn, me) { return function () { return fn.apply(me, arguments); }; };

Notifications = (function () {
  function Notifications() {
    this.handleSucess = bind(this.handleSucess, this);
    this.handleClick = bind(this.handleClick, this);
    this.notifications = $("[data-behavior='notifications']");
    if (this.notifications.length > 0) {
      $("[data-link='notifications-link']").on('click', this.handleClick);
      this.handleSucess(this.notifications.data('notifications'));

      /*setInterval(((function (_this) {
        return function () {
          return _this.getNewNotifications();
        };
      })(this)), 5000);*/
    }
  }

  Notifications.prototype.getNewNotifications = function () {
    return $.ajax({
      url: '/notifications.json',
      dataType: 'JSON',
      method: 'GET',
      success: this.handleSucess,
    });
  };

  Notifications.prototype.handleClick = function (e) {
    return $.ajax({
      url: '/notifications/mark_as_read',
      dataType: 'JSON',
      method: 'POST',
      success: function () {
        return $("[data-behavior='unread-count']").text(0);
      },
    });
  };

  Notifications.prototype.handleSucess = function (data) {
    var items, unreadCount;
    items = $.map(data, function (notification) {
      return notification.template;
    });
    var notificationsIndex = $("[data-behavior='notifications-index']");

    unreadCount = 0;
    $.each(data, function (i, notification) {
      if (notification.unread) {
        return unreadCount += 1;
      }
    });

    $("[data-behavior='unread-count']").text(unreadCount);
    $("[data-behavior='notification-items']").html(items);
    if (notificationsIndex.length > 0) {
      notificationsIndex.html(items);
    }
  };

  return Notifications;

})();
