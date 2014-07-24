class CommentsController < ApplicationController

  COMMENTABLES = [Library]

  respond_to :js

  before_filter :set_commentable, only: [:index, :create, :update, :destroy]
  before_filter :set_comment, only: [:update, :destroy]
  skip_before_filter :authenticate_user!, only: [:index]

  def index
    @comments = @commentable.comments.order(created_at: :desc).page(params[:comments_page])
  end

  def create
    comment_data = { user: current_user }.merge(comment_params)
    @comment = @commentable.comments.build(comment_data)

    authorize @comment

    if !@comment.save
      @message = I18n.t('flash.actions.create.alert', @comment)
    end
  end

  def destroy
    authorize @comment
    comment_id = @comment.id
    render :destroy, locals: {
      commentable_id: @commentable.id,
      comment_id: comment_id
    }
    @comment.destroy
  end

  private

  def set_commentable
    commentable_key = params.keys.select { |p| p.match(/[a-z_]_id$/) }.last

    # Class can be inferred from the key.
    # We're using the HEARTABLES array for protection though.
    commentable_class = COMMENTABLES.select do |klass|
      klass.to_s.downcase == commentable_key[0..-4]
    end.first

    @commentable = commentable_class.find(params[commentable_key])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:text)
  end
end
