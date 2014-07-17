class CommentsController < ApplicationController
  respond_to :js

  before_filter :set_commentable, only: [:index, :create, :update, :destroy]
  before_filter :set_comment, only: [:update, :destroy]

  def index
    @comments = @commentable.comments.order(created_at: :desc).page(params[:comments_page])
  end

  def create
    comment_data = {user: current_user}.merge(comment_params)
    @comment = @commentable.comments.build(comment_data)

    authorize @comment

    if !@comment.save
      @message = I18n.t('flash.create.alert')
    end
  end

  private

  def set_commentable
    # Get the class that is using comments
    commentable_key = params.keys.select { |p| p.match(/[a-z_]_id$/) }.last
    commentable_klass = commentable_key[0..-4].capitalize.constantize
    commentable_id = params[commentable_key]

    @commentable = commentable_klass.find(commentable_id)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:text)
  end
end
