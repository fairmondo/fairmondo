#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class LibraryElementObserver < ActiveRecord::Observer
  # A new element updates the library in general
  def after_save library_element
    update_library library_element
  end

  # A deleted element updates the library
  def after_destroy library_element
    update_library library_element
  end

  private

  def update_library library_element
    library_element.library.update_attribute(:updated_at, Time.now) if library_element.library
  end
end
