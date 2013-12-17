module TransactionRefund
  extend ActiveSupport::Concern
  extend Enumerize

  included do
    has_one :refund, inverse_of: :transaction

    #fields of refund model, that should be available through transaction
    delegate :description, :reason, to: :refund, prefix: true
  end

  enumerize :reason, in: [
    :sent_back,
    :not_paid,
    :not_in_stock,
    :voucher
  ]
  
  # Methods
  #
  # checks if user has requested refund for this transaction
  def requested_refund?
    ( self.refund && self.refund_reason && self.refund_description ) ? true : false
  end

  def refundable?
    self.seller.can_refund? self
  end
end
