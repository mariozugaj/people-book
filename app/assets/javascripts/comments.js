var PeopleBook = PeopleBook || {};

PeopleBook.CommentsModule = (function () {

  var init = function () {
    _commentLinkListener();
    _cancelCommentLinkListener();
  };

  var _commentLinkListener = function () {
    $(document).on('click', "[data-behavior='comment-link']", function (e) {
      e.preventDefault();
      var $linkContainer = $(e.target).parent();
      var $form = $linkContainer.next();
      $linkContainer.slideUp('fast', function () {
        $form.slideDown('fast');
      });
    });
  };

  var _cancelCommentLinkListener = function () {
    $(document).on('click', "[data-behavior='cancel-link']", function (e) {
      e.preventDefault();
      var $form = $(e.target).parent().parent();
      var $linkContainer = $form.prev();
      $linkContainer.slideDown('fast');
      $form.slideUp('fast');
    });
  };

  var _getCommentsContainer = function (parentId, parentType) {
    var $parent = $('[data-id="' + parentId + '"][data-type="' + parentType + '"]');
    return $parent.find('.ui.comments');
  };

  var _hideCommentForm = function (container) {
    var $formContainer = container.parent().siblings('.comment__form');
    var $linkContainer = $formContainer.prev();
    $linkContainer.slideDown('fast');
    $formContainer.slideUp('fast');
  };

  var _getComment = function (id) {
    return $('[data-id="' + id + '"][data-type="Comment"]');
  };

  var _clearForm = function ($container) {
    var form = $container.parent().siblings('.comment__form').children('form')[0];
    form.reset();
  };

  var _updateCommentsCount = function (container, commentsCount) {
    var $container = container.children('.comments_count');
    $container.html(commentsCount);
  };

  var addComment = function (parentId, parentType, comment, commentsCount) {
    var $container = _getCommentsContainer(parentId, parentType);
    var $comment = $(comment);
    $comment.appendTo($container).hide().slideDown('fast');;
    _updateCommentsCount($container, commentsCount);
    _clearForm($container);
    _hideCommentForm($container);
  };

  var removeComment = function (id, commentsCount, parentId, parentType) {
    var $container = _getCommentsContainer(parentId, parentType);
    var $comment = _getComment(id);
    _updateCommentsCount($container, commentsCount);
    $comment.slideUp('fast', function () {
      $(this).remove();
    });
  };

  return {
    init: init,
    addComment: addComment,
    removeComment: removeComment,
  };

})();

$(document).on('turbolinks:load', function () {
  PeopleBook.CommentsModule.init();
});
