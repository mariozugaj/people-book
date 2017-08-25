var App = App || {};

App.Likes = (function () {

  var init = function () {
    _showTooltip();
  };

  var _showTooltip = function () {
    $('.commentable').on('mouseover', "[data-behavior='like-count-container']", function (e) {
      if (e.target.innerText.trim() === '0 likes') {
        return e.target.dataset.tooltip = 'No one likes it yet.';
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

  var renderLikes = function (parentId, parentType, count, action) {
    var $countContainer = _getCountContainer(parentId, parentType);
    var $actionContainer = _getAction(parentId, parentType);
    var $action = $(action);
    $countContainer.html(count);
    $actionContainer.replaceWith($action);
  };

  return {
    init: init,
    renderLikes: renderLikes,
  };

})();

document.addEventListener('DOMContentLoaded', function () {
  return App.Likes.init();
});
