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
  actions :index, :create, :update, :destroy

  before_filter :render_users_hero , :if =>  :user_focused?
  before_filter :get_user, :if => :user_focused?

  # Authorization
  skip_before_filter :authenticate_user!, :only => [:index]

  def index
    @library = @user.libraries.build if user_signed_in? && @user
    @libraries = LibraryPolicy::Scope.new( current_user, @user, end_of_association_chain.includes(:user => [:image],:library_elements => [:article => [:images,:seller]] )).resolve.page(params[:page])

    render :global_index unless user_focused?
  end

  def create
    authorize build_resource
    create! do |success,failure|
      success.html { redirect_to user_libraries_path(@user, :anchor => "library#{@library.id}") }
      failure.html { redirect_to user_libraries_path(@user), :alert => @library.errors.values.first.first }
    end
  end

  def update
    authorize resource
    update! do |success,failure|
      success.html { redirect_to user_libraries_path(@user, :anchor => "library#{@library.id}") }
      failure.html { redirect_to user_libraries_path(@user), :alert => @library.errors.values.first.first }
    end
  end

  def destroy
    authorize resource
    destroy! { user_libraries_path(@user)}
  end

  private

    def begin_of_association_chain
      @user if user_focused?
    end

    # def collection
    #   @libraries ||= LibraryPolicy::Scope.new( current_user, @user , end_of_association_chain ).resolve
    # end

    def get_user
      @user = User.find(permitted_id_params[:user_id])
    end

    def user_focused?
      permitted_id_params.has_key? :user_id
    end

    def permitted_id_params
      params.permit :user_id
    end
end
