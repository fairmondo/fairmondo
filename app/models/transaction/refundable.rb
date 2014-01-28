module Transaction::Refundable
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
    ( self.refund && self.refund_reason && self.refund_description ) ? true : false
  end

  def refundable?
    ( self.seller.can_refund? self ) && ( !self.requested_refund? )
  end
end
