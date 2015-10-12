#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module User::ExtendedAttributes
  extend ActiveSupport::Concern

  included do
    extend Sanitization

    auto_sanitize :nickname, :bank_name
    auto_sanitize :iban, :bic, remove_all_spaces: true
    auto_sanitize :about_me, :terms, :cancellation, :about, method: 'tiny_mce'

    attr_accessor :wants_to_sell
    attr_accessor :bank_account_validation, :paypal_validation
    attr_accessor :fastbill_profile_update

    monetize :unified_transport_price_cents,
             numericality: {
               greater_than_or_equal_to: 0,
               less_than_or_equal_to: 50000
             }, allow_nil: true
    monetize :free_transport_at_price_cents,
             numericality: { greater_than_or_equal_to: 0 },
             allow_nil: true

    monetize :total_purchase_donations_cents,
             numericality: { greater_than_or_equal_to: 0 },
             allow_nil: true

    # directly increase donation cache
    def increase_purchase_donations! bt
      update_column :total_purchase_donations_cents,
                    (total_purchase_donations_cents + bt.total_fair_cents)
    end

    # directly decrease donation cache
    def decrease_purchase_donations! bt
      update_column :total_purchase_donations_cents,
                    (total_purchase_donations_cents - bt.total_fair_cents)
    end
  end
end
