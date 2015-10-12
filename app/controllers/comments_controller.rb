#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class CommentsController < ApplicationController
  include FindPolymorphicTarget

  # If you want to make another Class commentable,
  # add it to the COMMENTABLES-array
  COMMENTABLES = [Library, Article]

  respond_to :js

  before_action(only: [:index, :create, :update, :destroy]) { set_commentable(COMMENTABLES) }
  before_action :set_comment, only: [:update, :destroy]
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @comment = Comment.new
    @comments = @commentable.comments
    respond_to do |format|
      format.js do
        if params[:comments_page]
          @comments = @comments.page(params[:comments_page])
          render partial: 'comments/index_paginated', locals: {
            comments: @comments,
            commentable: @commentable
          }
        end
      end
    end
  end

  def create
    comment_data = { user: current_user }.merge(params.for(Comment).refine)
    @comment = @commentable.comments.build(comment_data)
    authorize @comment
    respond_to do |format|
      format.js do
        if @comment.save
          # In the view we are using the comments_count counter cache, which is not automatically
          # updated in the object, so we do it by hand.
          # Please don't save this object from now on.
          @commentable.comments_count += 1

          # if save was successful, please create a new comment object to render the input form with
          @new_comment = Comment.new
          render :create
        else
          render :new, comment: @comment, commentable: @commentable
        end
      end
    end
  end

  def destroy
    authorize @comment
    @comment.destroy

    # In the view we are using the comments_count counter cache, which is not automatically
    # updated in the object, so we do it by hand.
    # Please don't save this object from now on.
    @commentable.comments_count -= 1
    respond_to do |format|
      format.js
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end
end
