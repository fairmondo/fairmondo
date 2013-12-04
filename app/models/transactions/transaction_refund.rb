module TransactionRefund
  extend ActiveSupport::Concern

  included do
    has_one :refund, inverse_of: :transaction

    #fields of refund model, that should be available through transaction
    delegate :description, :reason, to: :refund, prefix: true
  end
  
  # Methods
  #
  # checks if user has requested refund for this transaction
  def requested_refund?
    !!( refund && refund_reason && refund_description )
  end

  def refundable?
    self.seller.can_refund? self
  end
end
