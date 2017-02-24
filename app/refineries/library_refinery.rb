#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class LibraryRefinery < ApplicationRefinery
  def default
    permitted = [:name, :public, :user, :user_id]
    permitted += [:exhibition_name] if User.is_admin? user
    permitted
  end
end
