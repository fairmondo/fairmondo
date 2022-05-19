#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class PaymentPolicy < Struct.new(:user, :payment)
  def create?
    user && buyer_is_user? && !payment.succeeded? && type_allowed?
  end

  def show?
    create?
  end

  private

  def buyer_is_user?
    payment.line_item_group_buyer == user
  end

  def type_allowed?
    payment.line_item_group.business_transactions.map(&:selected_payment).map do |p|
      Payment.parse_type p
    end.include? payment.type
  end
end
