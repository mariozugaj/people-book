class CommentsController < ApplicationController
  include FindPolymorphic

  def create
    @commentable = find_polymorphic(params)
    @comment = @commentable.comments.build(comment_params)
    authorize @comment
    if @comment.save
      flash[:success] = 'Comment successfuly posted'
      respond_to do |format|
        format.html { redirect_to request.referrer || root_path }
        format.js
      end
    else
      flash[:alert] = 'There was a problem posting your comment. Try again?'
      respond_to do |format|
        format.html { redirect_to request.referrer || root_path }
        format.js { render partial: 'shared/flash_js' }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    authorize @comment
    if @comment.destroy
      flash[:success] = 'Your comment was destroyed'
      respond_to do |format|
        format.html { redirect_to request.referrer || root_path }
        format.js
      end
    else
      flash[:alert] = 'There was a problem destroying your comment. Try again?'
      respond_to do |format|
        format.html { redirect_to request.referrer || root_path }
        format.js { render partial: 'shared/flash_js' }
      end
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:text, :commentable_type, :commentable_id,
                                    :author_id)
  end
end
