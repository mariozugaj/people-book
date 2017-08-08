var Notifications,
  bind = function (fn, me) { return function () { return fn.apply(me, arguments); }; };

Notifications = (function () {
  function Notifications() {
    this.handleSucess = bind(this.handleSucess, this);
    this.handleClick = bind(this.handleClick, this);
    $("[data-link='notifications-link']").on('click', this.handleClick);
    this.getNewNotifications();
    setInterval(((function (_this) {
      return function () {
        return _this.getNewNotifications();
      };
    })(this)), 5000);
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
        return $("[data-behavior='unread-count']").text(0).removeClass('red');
      },
    });
  };

  Notifications.prototype.handleSucess = function (data) {
    var items, unreadCount, $unreadLabel, $notificationsContainer, itemsLenght;
    items = $.map(data.results.notifications, function (notification) {
      return notification.template;
    });
    $unreadLabel = $("[data-behavior='unread-count']");
    $notificationsContainer = $("[data-behavior='notification-items']");
    unreadCount = 0;
    itemsLength = items.length;

    $.each(data.results.notifications, function (i, notification) {
      if (notification.unread) {
        return unreadCount += 1;
      }
    });

    if (unreadCount > 0) {
      $unreadLabel.addClass('red');
      $unreadLabel.text(unreadCount);
    };

    if (itemsLength > 0) {
      $notificationsContainer.siblings().remove();
      $notificationsContainer.html(items);
    } else {
      $("<span class='item'>No new notifications</span>").insertBefore($notificationsContainer);
    };

    if (data.results.total > itemsLength) {
      $("<a class='active item center-text' href='/notifications'>See all</a>").insertBefore($notificationsContainer);
    }
  };

  return Notifications;

})();

$(function () {
  return new Notifications;
});
