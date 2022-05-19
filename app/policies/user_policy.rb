#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class UserPolicy < Struct.new(:user, :resource)
  def profile?
    true unless banned? || (now_confirmed? == false) # prueft ob gebannt oder nicht confirmed.
  end

  def show?
    true unless banned? || (now_confirmed? == false) # prueft ob gebannt oder nicht.
  end

  # policy for creating a direct debit mandate
  # todo: better naming
  def create?
    true unless banned?
  end

  private

  def banned?
    resource.banned?
  end

  def now_confirmed?
    resource.confirmed?       # now_confirmed um confirmed nicht aus Versehen zu ueberschreiben, devise methode ggf. auch rails' '
  end
end
