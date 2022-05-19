#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class CreatesDirectDebitMandate
  def initialize(user)
    @user = user
  end

  def create
    unless @user.has_active_direct_debit_mandate?
      create_and_activate_mandate
      save_user
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
    mandate_number = @user.increase_direct_debit_mandate_number
    build_mandate_reference(mandate_number)
    @mandate.save
  end

  def build_mandate_reference(mandate_number)
    num_str = mandate_number.to_s.rjust(3, '0')
    @mandate.reference = "#{@user.id}-#{num_str}"
  end

  def activate_mandate
    @mandate.activate!
  end

  def save_user
    @user.save
  end
end
