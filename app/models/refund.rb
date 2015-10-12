#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class Refund < ActiveRecord::Base
  extend Enumerize
  extend Sanitization
  extend Tokenize

  belongs_to :business_transaction

  validates :reason, presence: true
  validates :description, presence: true,
                          length: {
                            minimum: 150,
                            maximum: 1000,
                            tokenizer: tokenizer_without_html }
  validates :business_transaction_id, presence: true, uniqueness: true

  delegate :seller, :seller_nickname, to: :business_transaction, prefix: true

  enumerize :reason, in: [
    :sent_back,
    :not_paid,
    :not_in_stock,
    :voucher
  ], default: :sent_back

  auto_sanitize :description
end
