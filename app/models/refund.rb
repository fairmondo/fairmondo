class Refund < ActiveRecord::Base
  extend Enumerize
  extend Sanitization

  def self.refund_attrs
    [ :reason, :description ]
  end

  belongs_to :transaction, class_name: 'Transaction', foreign_key: 'transaction_id', inverse_of: :refund

  validates :reason, presence: true
  validates :description, presence: true, length: { minimum: 150, maximum: 300 }
  validates :transaction_id, presence: true, uniqueness: true

  delegate :seller, to: :transaction, prefix: true

  enumerize :reason, in: [
    :sent_back,
    :not_paid,
    :not_in_stock,
    :voucher
  ], default: :sent_back

  auto_sanitize :description


  # This must be reenabled when fastbill stuff comes online
  # after_create :fastbill_refund

 #  private
 #    def fastbill_refund
 #      [ :fair, :fee ].each do | fee_type |
 #        FastbillAPI.fastbill_refund( self.transaction, fee_type )
 #      end
 #    end
end
