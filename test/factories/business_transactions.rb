#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'ffaker'

FactoryGirl.define do
  factory :business_transaction do
    association :seller, factory: [:legal_entity_that_can_sell, :with_paypal_account]
    association :buyer, factory: :regular_private_user

    association :article, factory: [:article, :with_fixture_image, :with_all_payments,
                                    :with_all_transports], quantity: 2
    association :line_item_group, factory: [:line_item_group, :sold]

    selected_transport 'type1'
    selected_payment 'bank_transfer'
    sold_at { Time.now }
    discount_value_cents 0
    quantity_bought 1

    trait :incomplete do
      shipping_address nil
    end

    trait :bought_nothing do
      quantity_bought 0
    end

    trait :bought_ten do
      quantity_bought 10
    end

    trait :bought_five do
      quantity_bought 5
    end

    trait :clear_fastbill do
      after :create do |business_transaction, _evaluator|
        business_transaction.seller.update_column(:fastbill_id, nil)
        business_transaction.seller.update_column(:fastbill_subscription_id, nil)
      end
    end

    trait :old do
      after :create do |business_transaction, _evaluator|
        business_transaction.update_attribute(:sold_at, 27.days.ago)
      end
    end

    trait :older do
      after :create do |business_transaction, _evaluator|
        business_transaction.update_attribute(:sold_at, 44.days.ago)
      end
    end

    trait :discountable do
      article { FactoryGirl.create :article, :with_discount }
    end

    trait :pickup do
      selected_transport :pickup
    end

    trait :transport_type1 do
      selected_transport :type1
    end

    trait :transport_type2 do
      selected_transport :type2
    end

    trait :transport_bike_courier do
      selected_transport :bike_courier
      tos_bike_courier_accepted true
      bike_courier_time { self.seller.pickup_time.sample }
      bike_courier_message 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
    end

    trait :cash do
      selected_payment 'cash'
    end

    trait :paypal do
      selected_payment 'paypal'
    end

    trait :invoice do
      selected_payment 'invoice'
    end

    trait :cash_on_delivery do
      selected_payment 'cash_on_delivery'
    end

    trait :bank_transfer do
      selected_payment 'bank_transfer'
    end

    trait :voucher do
      selected_payment 'voucher'
    end
  end
end
