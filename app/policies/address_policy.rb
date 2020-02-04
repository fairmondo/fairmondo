#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class AddressPolicy < Struct.new(:user, :address)
  def new?
    own?
  end

  def create?
    own?
  end

  def show?
    own?
  end

  def edit?
    own?
  end

  def update?
    own?
  end

  def destroy?
    own? && !standard_address?
  end

  private

  def standard_address?
    user.standard_address == address
  end

  def own?
    user.present? && user == address.user
  end
end
