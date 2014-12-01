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
class VoucherPayment < Payment
  extend STI

  has_many :business_transactions, -> { where selected_payment: :voucher }, through: :line_item_group

  def after_create_path
    :back
  end

  # Code "15ABC" = 15 Euro
  def voucher_value
    Money.new(pay_key.match(/\A\d+/)[0].to_i * 100)
  end

  # @return [Boolean]
  def covers total
    voucher_value >= total
  end

  def donated_amount_from total
    voucher_value - total
  end

  def missing_amount_from total
    total - voucher_value
  end
end
