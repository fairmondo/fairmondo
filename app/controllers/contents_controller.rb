#
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
class ContentsController < ApplicationController
  responders :flash
  respond_to :html
  skip_before_filter :authenticate_user!, only: :show
  before_filter :set_content, only: [:edit, :update, :destroy]

  def index
    @contents = Content.all
    respond_with @contents
  end

  def show
    set_content
    authorize @content
    respond_with @content
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
