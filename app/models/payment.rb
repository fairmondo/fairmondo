#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class Payment < ActiveRecord::Base
  has_many :business_transactions, through: :line_item_group # +multiple bt can have one payment, if unified
  belongs_to :line_item_group, inverse_of: :payments
  # # all bts will have the same line_item_group, so it's actually has_one, but rails doesn't understand that
  # def line_item_group; line_item_groups.first; end # simulate the has_one

  delegate :buyer, :buyer_id, :seller, :seller_email, :buyer_email, :purchase_id,
           :seller_paypal_account,
           to: :line_item_group, prefix: true

  validates :pay_key, uniqueness: true, on: :create
  validates :line_item_group_id, uniqueness: true, on: :create

  state_machine initial: :pending do
    state :pending, :initialized, :errored, :succeeded, :confirmed

    event :init do
      transition pending: :initialized, if: :initialize_payment
      transition pending: :errored
    end

    event :success do
      transition initialized: :succeeded
    end

    event :confirm do
      transition [:pending, :initialized] => :confirmed
    end

    event :decline do
      transition [:pending, :initialized] => :errored
    end
  end

  def execute
    self.init && !self.errored?
  end

  def total_price
    Abacus.new(line_item_group).payment_listing.payments[:paypal][:total]
  end

  def self.parse_type selected_payment
    case selected_payment
    when 'paypal', :paypal
      'PaypalPayment'
    when 'voucher', :voucher
      'VoucherPayment'
    else
      nil
    end
  end

  protected

  # called within init
  def initialize_payment
    true
  end
end
