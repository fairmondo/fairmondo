#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

FactoryBot.define do
  factory :business_transaction do
    association :seller, factory: [:user, :paypal_data]
    association :buyer, factory: :user

    state { :sold }

    transient do
      article_attributes { Hash.new }
      article_all_attributes do
        article_attributes.merge(seller: seller, quantity: (quantity_bought + 1))
      end
    end

    article do
      create :article, :with_fixture_image, :with_all_payments, :with_all_transports,
             article_all_attributes
    end
    line_item_group { create :line_item_group, :sold, seller: seller, buyer: buyer }

    selected_transport { 'type1' }
    selected_payment { 'bank_transfer' }
    sold_at { Time.now }
    discount_value_cents { 0 }
    quantity_bought { 1 }

    factory :business_transaction_from_private_user, traits: [:from_private_user]
    factory :business_transaction_from_legal_entity, traits: [:from_legal_entity]
    factory :business_transaction_from_ngo, traits: [:from_ngo]
    factory :business_transaction_from_marketplace_owner_account, traits: [:from_marketplace_owner_account]

    trait :incomplete do
      shipping_address { nil }
    end

    trait :bought_nothing do
      quantity_bought { 0 }
    end

    trait :bought_ten do
      quantity_bought { 10 }
    end

    trait :bought_five do
      quantity_bought { 5 }
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
      association :article, factory: [:article, :with_discount]
    end

    trait :from_private_user do
      association :seller, factory: [:private_user, :paypal_data]
    end

    trait :from_legal_entity do
      association :seller, factory: [:legal_entity, :paypal_data]
    end

    trait :from_ngo do
      association :seller, factory: [:ngo, :paypal_data]
    end

    trait :from_marketplace_owner_account do
      association :seller, factory: [:legal_entity, :paypal_data, :marketplace_owner_account]
    end

    trait :pickup do
      selected_transport { :pickup }
    end

    trait :transport_type1 do
      selected_transport { :type1 }
    end

    trait :transport_type2 do
      selected_transport { :type2 }
    end

    trait :transport_bike_courier do
      selected_transport { :bike_courier }
      tos_bike_courier_accepted { true }
      bike_courier_time { self.seller.pickup_time.sample }
      bike_courier_message do
        'Suffering has been stronger than all other teaching, and has taught '\
        'me to understand what your heart used to be. I have been bent and broken, but - I hope '\
        '- into a better shape.'
      end
    end

    trait :cash do
      selected_payment { 'cash' }
    end

    trait :paypal do
      selected_payment { 'paypal' }
    end

    trait :invoice do
      selected_payment { 'invoice' }
    end

    trait :cash_on_delivery do
      selected_payment { :cash_on_delivery }
    end

    trait :bank_transfer do
      selected_payment { 'bank_transfer' }
    end

    trait :voucher do
      selected_payment { 'voucher' }
    end
  end
end
