#
#
# == License:
# Fairmondo - Fairmondo is an open-source online marketplace.
# Copyright (C) 2013 Fairmondo eG
#
# This file is part of Fairmondo.
#
# Fairmondo is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairmondo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairmondo.  If not, see <http://www.gnu.org/licenses/>.
#
class PaymentPolicy < Struct.new(:user, :payment)
  def create?
    user && buyer_is_user? && !payment.succeeded? && type_allowed?
  end

  def show?
    create?
  end

  private
    def buyer_is_user?
      payment.line_item_group_buyer_id == user.id
    end

    def type_allowed?
      payment.line_item_group.business_transactions.map(&:selected_payment).map do |p|
        Payment.parse_type p
      end.include? payment.type
    end
end
