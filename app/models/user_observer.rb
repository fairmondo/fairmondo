#
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly. If not, see <http://www.gnu.org/licenses/>.
#

class UserObserver < ActiveRecord::Observer
  def before_save(user)
    if ( user.bank_account_number_changed? ||  user.bank_code_changed? )
      check_bank_details( user.id, user.bank_account_number, user.bank_code )
    end
  end

  # this should update the users data with fastbill after the user edits his data
  # def after_save(user)
  #   if user.has_fastbill_profile?
  #     FastbillAPI.fastbill_update_user user
  #   end
  # end

  #handle_asynchronously :check_bank_details

  def check_bank_details(id, bank_account_number, bank_code)
    begin
      user = User.find_by_id(id)
      user.update_column( :bankaccount_warning, !KontoAPI::valid?( :ktn => bank_account_number, :blz => bank_code ) )
    rescue
    end
  end
end
