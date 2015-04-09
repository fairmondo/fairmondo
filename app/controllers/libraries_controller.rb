# -*- coding: utf-8 -*-
#
#
# == License:
# Fairmondo - Fairmondo is an open-source online marketplace.
# Copyright (C) 2013 Fairmondo eG
#
# This file is part of Fairmondo.
#
# Fairmondo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairmondo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
#
class LibrariesController < ApplicationController
  helper_method :user_focused?

  respond_to :html

  before_action :set_user, if: :user_focused?, only: :index
  before_action :set_library, only: [:show, :update, :destroy, :admin_audit]
  before_action :set_exhibition, only: :admin_add

  # Authorization
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    # Build empty Library object if user creates a new library
    @library = @user.libraries.build if signed_in_user_with_focus?

    if signed_in_or_not_favorite?
      @libraries = LibraryPolicy::Scope.new(current_user, @user, focus.includes(user: [:image]))
        .resolve
        .page(params[:page])
        .per(12)
    end

    respond_to do |format|
      format.html
    end
  end

  def show
    authorize @library
    respond_with @library do |format|
      format.js
    end
  end

  def create
    @library = current_user.libraries.build(params.for(Library).refine)
    authorize @library

    # Both .js responses are only for the articles view!
    respond_with @library do |format|
      if @library.save
        format.html { redirect_to user_libraries_path(current_user, anchor: "library#{@library.id}") }
        format.js
      else
        format.html { redirect_to user_libraries_path(current_user), alert: @library.errors.values.first.first }
        format.js { render :new }
      end
    end
  end

  def update
    authorize @library
    if @library.update(params.for(@library).refine)
      redirect_to user_libraries_path(current_user, anchor: "library#{@library.id}")
    else
      redirect_to user_libraries_path(current_user), alert: @library.errors.values.first.first
    end
  end

  def destroy
    authorize @library
    @library.destroy
    redirect_to user_libraries_path(current_user)
  end

  # for admins to quickly add one or more articles to any library
  def admin_add
    authorize @exhibition
    add_articles_to_exhibition if can_add_to_exhibition?
    redirect_to :back, flash: @admin_add_notice
  end
  #
  # for admins to quickly remove an article from a featured library
  def admin_remove
    library = Library.where(exhibition_name: params[:exhibition_name]).first
    authorize library

    library.articles.delete Article.find(params[:article_id])
    redirect_to :back, notice: 'Deleted from library.'
  end

  # for admins to audit libraries for display on the welcome page
  def admin_audit
    authorize @library
    @library.update_column :audited, !@library.audited
    respond_with @library do |format|
      format.js { render 'admin_audit' }
    end
  end

  private

  def set_library
    @library = Library.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def user_focused?
    params.key?(:user_id)
  end

  def focus
    case
    when user_focused?
      @user.libraries
    when index_mode == 'trending'
      Library.trending
    when index_mode == 'myfavorite'
      current_user.hearted_libraries.reorder('hearts.created_at DESC')
    when index_mode == 'new'
      Library
    end
  end

  # Configure the libraries collection that is displayed
  def index_mode
    @mode ||= params[:mode] || 'new'
  end

  def signed_in_user_with_focus?
    user_signed_in? && user_focused?
  end

  def signed_in_or_not_favorite?
    user_signed_in? || index_mode != 'myfavorite'
  end

  def set_exhibition
    @exhibition = Library
      .where(exhibition_name: params[:library][:exhibition_name])
      .first
  end

  def can_add_to_exhibition?
    params[:library][:exhibition_name] &&
      (params[:library][:articles] ||
       params[:library][:article_id])
  end

  def add_articles_to_exhibition
    @exhibition.articles << Article.find(article_ids_from_params)
    @admin_add_notice = { notice: 'Added to library.' }
  rescue => err
    # will throw errors e.g. if library already had that article
    # Only visible for admins
    @admin_add_notice = { error: "Something went wrong: #{err}" }
  end

  def article_ids_from_params
    (params[:library][:articles] || [params[:library][:article_id]])
      .select(&:present?)
  end
end
