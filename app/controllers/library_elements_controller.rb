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
class LibraryElementsController < ApplicationController
  before_action :set_library_element, except: :create

  def create
    @library_element =
      current_user.library_elements.build(params.for(LibraryElement).refine)
    authorize @library_element
    if @library_element.save
      flash[:notice] =
        I18n.t('library_element.notice.success',
               href: library_path(@library_element.library),
               title: @library_element.library_name
        ).html_safe
    end

    redirect_to :back
  end

  def destroy
    authorize @library_element
    @library_element.destroy
    redirect_to library_url(@library_element.library)
  end

  private

  def set_library_element
    @library_element = LibraryElement.find(params[:id])
  end
end
