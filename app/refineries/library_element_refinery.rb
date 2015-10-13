#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class LibraryElementRefinery < ApplicationRefinery
  def default
    [:article, :library, :library_id, :article_id]
  end
end
