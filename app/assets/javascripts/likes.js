var PeopleBook = PeopleBook || {};

PeopleBook.LikesModule = (function () {

  var init = function () {
    _likeTooltip();
  };

  var _likeTooltip = function () {
    $('.likes.count').popup();
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
