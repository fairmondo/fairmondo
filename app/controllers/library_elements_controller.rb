#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

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
