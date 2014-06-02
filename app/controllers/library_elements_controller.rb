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
class LibraryElementsController < InheritedResources::Base
  respond_to :html
  actions :create, :update, :destroy
  before_filter :get_user

  def create
    authorize build_resource
    create! do |success,failure|
      success.html { redirect_to article_path(@library_element.article), :notice => I18n.t('library_element.notice.success' , :name => @library_element.library_name) }
      failure.html { redirect_to article_path(@library_element.article), :alert => @library_element.errors.messages[:library_id].first}
    end
  end

  def update
    authorize resource
    update! do |success,failure|
      success.html { redirect_to user_libraries_path(@user, :anchor => "library"+@library_element.library.id.to_s)  }
      failure.html { redirect_to user_libraries_path(@user) , :alert => @library_element.errors.messages[:library_id].first}
    end
  end

  def destroy
    authorize resource
    destroy! { user_libraries_path(@user , :anchor => "library"+resource.library.id.to_s )}
  end

  private
    def get_user
      @user = User.find params.permit(:user_id)[:user_id]
    end
end
