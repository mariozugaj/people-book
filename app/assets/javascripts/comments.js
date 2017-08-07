var App = App || {};

App.Comments = (function () {

  var init = function () {
    _commentLinkListener();
    _cancelCommentLinkListener();
    _showCommentsListener();
  };

  var _commentLinkListener = function () {
    $("[data-behavior='comment-link']").on('click', function (e) {
      e.preventDefault();
      var $form = $(e.target).parents('.content.statistics')
                             .siblings("[data-behavior='comment-form']");
      $form.slideDown('fast');
    });
  };

  var _cancelCommentLinkListener = function () {
    $("[data-behavior='cancel-link']").on('click', function (e) {
      e.preventDefault();
      var $form = $(e.target).parents('.comment__form');
      $form.slideUp('fast');
    });
  };

  var _showCommentsListener = function () {
    $("[data-behavior='show-comments']").on('click', function (e) {
      var $commentsContainer = $(e.target).parents('.commentable').find('.comments.content');
      if ($commentsContainer.length == 0 && e.target.innerText !== '0 comments') {
        var link = e.target.dataset.link;
        var $linkParent = $(e.target).parents('.commentable');
        _showComments(link, $linkParent);
      };
    });
  };

  var _getCommentsContainer = function (parentId, parentType) {
    var $parent = $('[data-id="' + parentId + '"][data-type="' + parentType + '"]');
    return $parent.find('.ui.comments');
  };

  var _getParent = function (parentId, parentType) {
    return $('[data-id="' + parentId + '"][data-type="' + parentType + '"]');
  };

  var _getCommentsLink = function (parentId, parentType) {
    var $parent = _getParent(parentId, parentType);
    var $link = $parent.find('.comments_count');
    return $link.data('link');
  };

  var _getComment = function (id) {
    return $('[data-id="' + id + '"][data-type="Comment"]');
  };

  var _hideCommentForm = function (container) {
    var $formContainer = container.find('.comment__form');
    $formContainer.slideUp('fast');
  };

  var _clearForm = function (container) {
    var form = container.find('.comment__form').find('form')[0];
    form.reset();
  };

  var _updateCommentsCount = function (container, commentsCount) {
    var $countContainer = container.find('.comments_count');
    $countContainer.html(commentsCount);
  };

  var _showComments = function (link, linkParent) {
    var $commentsContainer = $("<div class='comments content' style='position: relative;'><h4>Comments</h4></div>");
    var $uiComments = $("<div class='ui comments' style='max-width: 100%'></div>");
    var $uiLoader = $("<div class='ui active mini loader'></div>");

    $.ajax({
      url: link,
      method: 'GET',
      dataType: 'HTML',
      success: function (data) {
        $uiComments.html(data).hide().appendTo($commentsContainer);
        $uiLoader.remove();
        App.Images.init();
        $uiComments.slideDown('slow');
      },
    });

    $uiLoader.appendTo($commentsContainer);
    $commentsContainer.appendTo(linkParent).slideDown('fast');
  };

  var addComment = function (parentId, parentType, comment, commentsCount) {
    var $container = _getCommentsContainer(parentId, parentType);
    var link = _getCommentsLink(parentId, parentType);
    var parent = _getParent(parentId, parentType);
    var $comment = $(comment);

    if ($container.length == 0) {
      _showComments(link, parent);
    };

    $comment.appendTo($container).hide().slideDown('fast', function () {
      $('html, body').animate({
        scrollTop: $comment.offset().top,
      }, 1000);
    });

    _updateCommentsCount(parent, commentsCount);
    _clearForm(parent);
    _hideCommentForm(parent);
  };

  var removeComment = function (id, commentsCount, parentId, parentType) {
    var $container = _getCommentsContainer(parentId, parentType);
    var $parent =  _getParent(parentId, parentType);
    var $comment = _getComment(id);
    _updateCommentsCount($parent, commentsCount);
    $comment.slideUp('fast', function () {
      $(this).remove();
      if ($container.children().length === 0) {
        $container.parent().slideUp('fast', function () {
          this.remove();
        });
      };
    });
  };

  return {
    init: init,
    addComment: addComment,
    removeComment: removeComment,
  };

})();

document.addEventListener('DOMContentLoaded', function () {
  return App.Comments.init();
});
