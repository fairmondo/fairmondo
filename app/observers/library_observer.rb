#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class LibraryObserver < ActiveRecord::Observer
  # Set audited to false when the library is changed
  def before_save(library)
    library.audited = false
    true
  end
end
