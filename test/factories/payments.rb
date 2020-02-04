#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

FactoryBot.define do
  factory :paypal_payment do
    state { :pending }
    association :line_item_group, factory: [:line_item_group, :sold, :with_business_transactions],
                                  traits: [:paypal, :transport_type1]

    factory :paypal_payment_with_pay_key, traits: [:with_pay_key]

    trait :with_pay_key do
      pay_key { 'foobar' }
    end
  end

  factory :voucher_payment do
    state { :pending }
    sequence(:pay_key) { |n| "20abc#{n}" }
    association :line_item_group, factory: [:line_item_group, :sold, :with_business_transactions,
                                            :with_voucher_seller],
                                  traits: [:voucher, :transport_type1]
  end
end
