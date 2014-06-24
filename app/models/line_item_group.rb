class LineItemGroup < ActiveRecord::Base
  belongs_to :seller, class_name: 'User', foreign_key: 'user_id', inverse_of: :line_item_groups
  belongs_to :cart, inverse_of: :line_item_groups
  has_many :line_items, dependent: :destroy, inverse_of: :line_item_group

  attr_accessor :selected_unified_transport, :selected_unified_payment

  # validates_presence_of :selected_unified_transport # this was only for testing purposes, right?

  def transport_can_be_unified?
    unified_transports_selectable.any?
  end

  def unified_transports_selectable
    @unified_transports_selectable ||= self.line_items.map{|l| l.business_transaction.article.selectable_transports}.inject(:&) #intersection of selectable_transports
  end

  def payment_can_be_unified?
    unified_payments_selectable.any?
  end

  def unified_payments_selectable
    @unified_payments_selectable ||= self.line_items.map{|l| l.business_transaction.article.selectable_transports}.inject(:&) #intersection of selectable_payments
  end

end
