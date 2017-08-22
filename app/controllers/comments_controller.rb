class CommentsController < ApplicationController
  include FindPolymorphic

  def index
    @commentable = find_polymorphic(params)
    @comments = @commentable.comments
                            .includes([:commentable, :likers, author: :profile])
                            .page(params[:page])
  end

  def create
    @commentable = find_polymorphic(params)
    @comment = @commentable.comments.build(comment_params)
    authorize @comment
    if @comment.save
      send_notification(@comment, @commentable)
      flash[:success] = 'Comment successfuly posted'
    else
      flash[:alert] = 'There was a problem posting your comment. Try again?'
      render partial: 'shared/flash_js'
    end
  end

  def destroy
    @comment = Comment.find_by_slug(params[:id])
    authorize @comment
    if @comment.destroy
      flash[:success] = 'Your comment was destroyed'
    else
      flash[:alert] = 'There was a problem destroying your comment. Try again?'
      render partial: 'shared/flash_js'
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:text, :commentable_type, :commentable_id,
                                      :author_id)
    end

    def send_notification(comment, commentable)
      recipients = (commentable.commenters +
                    [commentable.author] +
                    commentable.likers).uniq -
                    [current_user]
      NotificationRelayJob.perform_later(recipients,
                                         current_user,
                                         'posted',
                                         comment)
    end
end
