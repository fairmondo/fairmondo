#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class RefundPolicy < Struct.new(:user, :refund)
  def create?
    return false if user.blank?

    own? && refund_possible?
  end

  def new?
    create?
  end

  private

  def own?
    user == refund.business_transaction_seller
  end

  # this method checks if the business_transaction is in a state in which it is possible
  # for it to request a refund
  # The construction of the statement seems a bit odd, as it checks on an instance
  # of Refund itself, this is possible as Refund.create creates a new instance which
  # is not yet saved to the db and as such has no association with a business_transaction
  # instance
  #
  def refund_possible?
    refund.business_transaction.sold? && refund.business_transaction.refundable?
  end
end
