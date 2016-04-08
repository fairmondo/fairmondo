#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class CreatesDirectDebitMandate
  def initialize(user)
    @user = user
  end

  def create
    unless @user.has_active_direct_debit_mandate?
      create_and_activate_mandate
    end
  end

  private

  def create_and_activate_mandate
    mandate = @user.direct_debit_mandates.create
    mandate.activate!
  end
end
