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

  enumerize :reason, in: ['Gutschein', 'Kaufer hat nicht bezahlt']

  auto_sanitize :description

  after_create :fastbill_refund

  private
    def fastbill_refund
      FastbillAPI.fastbill_refund( self.transaction, :fair )
      FastbillAPI.fastbill_refund( self.transaction, :fee )
    end
end
