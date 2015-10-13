#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class HeartPolicy < Struct.new(:user, :heart)
  def create?
    true
  end

  def destroy?
    own?
  end

  private

  def own?
    user && user.id == heart.user_id
  end
end
