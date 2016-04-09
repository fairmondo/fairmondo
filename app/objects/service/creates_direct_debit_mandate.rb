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
    @mandate
  end

  private

  def create_and_activate_mandate
    create_mandate
    activate_mandate
  end

  def create_mandate
    @mandate = @user.direct_debit_mandates.build

    num = @user.next_direct_debit_mandate_number
    @user.next_direct_debit_mandate_number += 1
    num_str = num.to_s.rjust(3, '0')
    @mandate.reference = "#{@user.id}-#{num_str}"

    @mandate.save
  end

  def activate_mandate
    @mandate.activate!
  end
end
