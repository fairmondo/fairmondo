#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module BusinessTransaction::Refundable
  extend ActiveSupport::Concern

  included do
    has_one :refund, inverse_of: :business_transaction

    # fields of refund model, that should be available through transaction
    delegate :description, :reason, to: :refund, prefix: true
  end

  # Methods
  #
  # checks if user has requested refund for this transaction
  def requested_refund?
    Refund.where(business_transaction_id: self.id).any?
  end

  def refundable?
    (self.seller.can_refund? self) && (!self.requested_refund?)
  end
end
