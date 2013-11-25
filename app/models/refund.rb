class Refund
  belongs_to :transaction, class_name: 'Transaction', foreign_key: 'transaction_id', inverse_of: :transaction

  validates :refund_reason, presence: true
  validates :refund_explanation, presence: true

  #methods
  def self.has_refund_request transaction
   
  end
end
