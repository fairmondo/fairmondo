#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

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
