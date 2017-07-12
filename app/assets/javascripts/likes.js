var PeopleBook = PeopleBook || {};

PeopleBook.LikesModule = (function () {

  var init = function () {
    _unlikeLinkListener();
  };

  var _unlikeLinkListener = function () {
    $(document).on('mouseenter mouseleave', '.likes.actions', function (e) {
      var link = $(this).find('.unlike');
      link.text(e.type == 'mouseenter' ? 'Unlike' : 'Liked');
    });
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

$(document).on('turbolinks:load', function () {
  PeopleBook.LikesModule.init();
  $('.likes.count').popup();
});
