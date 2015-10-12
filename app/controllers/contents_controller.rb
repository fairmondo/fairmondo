#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class ContentsController < ApplicationController
  responders :flash
  respond_to :html
  respond_to :js, if: lambda { request.xhr? }
  skip_before_action :authenticate_user!, only: :show
  before_action :set_content, only: [:edit, :update, :destroy]

  def index
    @contents = Content.all
    respond_with @contents
  end

  def show
    set_content
    authorize @content
    if params && params[:layout] == 'false'
      render 'clean_show', layout: false
    else
      respond_with @content
    end
  rescue ActiveRecord::RecordNotFound => e
    raise e unless User.is_admin? current_user
    authorize(Content.new, :new?)
    redirect_to new_content_path key: params[:id]
  end

  def new
    @content = Content.new
    @content.key = params[:key]
    authorize @content
    respond_with @content
  end

  def create
    @content = Content.new(params.for(Content).refine)
    authorize @content
    @content.save
    respond_with @content
  end

  def edit
    authorize @content
    respond_with @content
  end

  def update
    authorize @content
    @content.update(params.for(@content).refine)
    respond_with @content
  end

  def destroy
    authorize @content
    @content.destroy
    respond_with @content
  end

  private

  def set_content
    @content = Content.find(params[:id])
  end
end
