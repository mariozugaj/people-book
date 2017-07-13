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
    return $parent.find('.likes.count').first();
  };

  var _getActionsContainer = function (parentId, parentType) {
    var $parent = $('[data-id="' + parentId + '"][data-type="' + parentType + '"]');
    return $parent.find('.likes.actions').first();
  };

  var renderLikes = function (parentId, parentType, count, action) {
    var $countContainer = _getCountContainer(parentId, parentType);
    var $actionsContainer = _getActionsContainer(parentId, parentType);
    var $action = $(action);
    $countContainer.html(count);
    $actionsContainer.empty().append($action);
  };

  return {
    init: init,
    renderLikes: renderLikes,
  };

})();
