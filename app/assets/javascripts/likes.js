var PeopleBook = PeopleBook || {};

PeopleBook.LikesModule = (function () {

  var init = function () {
    _showTooltip();
  };

  var _showTooltip = function () {
    $("[data-behavior='like-count-container']").on('mouseover', function (e) {
      if (e.target.innerText === '0 likes ') {
        return e.target.dataset.tooltip = 'No one likes it yet. Be the first!';
      };

      var link = e.target.dataset.link;
      $.ajax({
        url: link,
        method: 'GET',
        dataType: 'HTML',
        success: function (data) {
          e.target.dataset.tooltip = data;
        },
      });
    });
  };

  var _getCountContainer = function (parentId, parentType) {
    var $parent = $('[data-id="' + parentId + '"][data-type="' + parentType + '"]');
    return $parent.find("[data-behavior='like-count-container']").first();
  };

  var _getAction = function (parentId, parentType) {
    var $parent = $('[data-id="' + parentId + '"][data-type="' + parentType + '"]');
    return $parent.find("[data-behavior='like-action']").first();
  };

  var renderLikes = function (parentId, parentType, count, action, tooltip) {
    var $countContainer = _getCountContainer(parentId, parentType);
    var $actionContainer = _getAction(parentId, parentType);
    var $action = $(action);
    $countContainer.html(count);
    $actionContainer.replaceWith($action);
    $countContainer[0].dataset.tooltip = tooltip;
  };

  return {
    init: init,
    renderLikes: renderLikes,
  };

})();
