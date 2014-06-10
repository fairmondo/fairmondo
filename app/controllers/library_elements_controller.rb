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
class LibraryElementsController < ApplicationController
  before_filter :set_library_element, except: :create

  def create
    @library_element = current_user.library_elements.build(params.for(LibraryElement).refine)
    authorize @library_element
    if @library_element.save
      redirect_to article_path(@library_element.article), :notice => I18n.t('library_element.notice.success' , :name => @library_element.library_name)
    else
      redirect_to article_path(@library_element.article), :alert => @library_element.errors.messages[:library_id].first
    end
  end

  def update
    authorize @library_element
    if @library_element.update(params.for(@library_element).refine)
      redirect_to user_libraries_path(current_user, :anchor => "library#{ @library_element.library.id }")
    else
      redirect_to user_libraries_path(current_user), :alert => @library_element.errors.messages[:library_id].first
    end
  end

  def destroy
    authorize @library_element
    @library_element.destroy
    redirect_to user_libraries_path(current_user, :anchor => "library#{ @library_element.library.id }")
  end

  private

    def set_library_element
      @library_element = LibraryElement.find(params[:id])
    end
end
