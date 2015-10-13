#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class UserPolicy < Struct.new(:user, :resource)
  def profile?
    true unless banned?
  end

  def show?
    true unless banned?
  end

  private

  def banned?
    resource.banned?
  end
end
