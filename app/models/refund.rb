class Refund < ActiveRecord::Base
  extend Enumerize
  extend Sanitization
  extend Tokenize

  belongs_to :transaction, class_name: 'Transaction', foreign_key: 'transaction_id', inverse_of: :refund

  validates :reason, presence: true
  validates :description, presence: true, length: { minimum: 150 }, length: { maximum: 1000, tokenizer: tokenizer_without_html }
  validates :transaction_id, presence: true, uniqueness: true

  delegate :seller, to: :transaction, prefix: true

  enumerize :reason, in: [
    :sent_back,
    :not_paid,
    :not_in_stock,
    :voucher
  ], default: :sent_back

  auto_sanitize :description
end
