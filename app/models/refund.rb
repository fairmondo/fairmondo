class Refund < ActiveRecord::Base
  extend Enumerize
  extend Sanitization
  extend Tokenize

  def self.refund_attrs
    [ :reason, :description ]
  end

  belongs_to :business_transaction

  validates :reason, presence: true
  validates :description, presence: true, length: { minimum: 150 }, length: { maximum: 1000, tokenizer: tokenizer_without_html }
  validates :business_transaction_id, presence: true, uniqueness: true

  delegate :seller, to: :business_transaction, prefix: true

  enumerize :reason, in: [
    :sent_back,
    :not_paid,
    :not_in_stock,
    :voucher
  ], default: :sent_back

  auto_sanitize :description
end
