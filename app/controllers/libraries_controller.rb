#
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
class LibrariesController < InheritedResources::Base
  respond_to :html
  actions :index, :create, :update, :destroy, :show
  custom_actions collection: :admin_add

  before_filter :render_users_hero , if: :user_focused?
  before_filter :get_user, if: :user_focused?

  # Authorization
  skip_before_filter :authenticate_user!, only: [:index, :show]

  def index
    @library = @user.libraries.build if user_signed_in? && @user
    @libraries = LibraryPolicy::Scope.new( current_user, @user, end_of_association_chain.includes(:user => [:image] )).resolve.page(params[:page])

    render :global_index unless user_focused?
  end

  def show
    authorize resource
    show! do |format|
      format.html
      format.js
    end
  end

  def create
    authorize build_resource
    create! do |success, failure|
      success.html { redirect_to user_libraries_path(@user, anchor: "library#{resource.id}") }
      failure.html { redirect_to user_libraries_path(@user), alert: resource.errors.values.first.first }
    end
  end

  def update
    authorize resource
    update! do |success, failure|
      success.html { redirect_to user_libraries_path(@user, anchor: "library#{resource.id}") }
      failure.html { redirect_to user_libraries_path(@user), alert: resource.errors.values.first.first }
    end
  end

  def destroy
    authorize resource
    destroy! { user_libraries_path(@user)}
  end

  # for admins to quickly add one or more articles to any library
  def admin_add
    authorize build_resource

    if params[:library][:exhibition_name] && (params[:library][:articles] || params[:library][:article_id])

      articles = params[:library][:articles] || [params[:library][:article_id]]
      library = Library.where(exhibition_name: params[:library][:exhibition_name]).first

      begin
        articles.each do |id|
          library.articles << Article.find(id) if id.present?
        end
        notice = {notice: "Added to library."}
      rescue => err #will throw errors e.g. if library already had that article
        notice = {error: "Something went wrong: #{err.to_s}"} # Only visible for admins
      end
    end
    redirect_to :back, flash: notice
  end

  #for admins to quickly remove an article from a featured library
  def admin_remove
    authorize build_resource

    article = Article.find(params[:article_id])
    library = Library.where(exhibition_name: params[:exhibition_name]).first

    library.articles.delete article

    redirect_to :back, notice: "Deleted from library."
  end

  private
    def begin_of_association_chain
      @user if user_focused?
    end

    # def collection
    #   @libraries ||= LibraryPolicy::Scope.new( current_user, @user , end_of_association_chain ).resolve
    # end

    def get_user
      @user = User.find(params.for(appropriate_resource).as(current_user).on(:user_focused).refine[:user_id])
    end

    def user_focused?
      params.has_key? :user_id
    end
end
