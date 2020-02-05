#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

FactoryBot.define do
  factory :line_item_group do
    association :cart
    association :seller, factory: :user
    association :buyer, factory: :user
    message { 'MyText' }
    tos_accepted { false }
    transport_address { buyer.standard_address }
    payment_address { create :address, user_id: buyer.id }
    purchase_id { 'F00000012' }

    transient do
      sold { false }
      articles { [create(:article, seller: seller)] }
    end

    after(:create) do |line_item_group, evaluator|
      evaluator.articles.each do |article|
        line_item_group
          .line_items << create(:line_item, article: article, line_item_group: line_item_group)
      end
    end

    trait :sold do
      transient do
        sold { true }
      end
      sold_at { Time.now }
      tos_accepted { true }
    end

    trait :with_business_transactions do
      association :seller, factory: [:legal_entity, :paypal_data]

      transient do
        articles_attributes { [] }
        articles { [] } # dont override
        create_line_items { false }
        traits { [[:paypal, :transport_type1], [:invoice, :transport_type2]] }
        build_or_create_bts { sold ? :create : :build }
      end

      after(:create) do |line_item_group, evaluator|
        evaluator.traits.each_with_index do |traits, index|
          attributes = FactoryBot
            .attributes_for(:business_transaction, *traits,
                            line_item_group: line_item_group, seller: line_item_group.seller,
                            article_attributes: evaluator.articles_attributes[index] || {})
          bt = line_item_group.business_transactions.send(evaluator.build_or_create_bts, attributes)
          if evaluator.create_line_items
            line_item_group.line_items << create(:line_item, article: bt.article)
          end
        end
      end
    end

    trait :with_voucher_seller do
      association :seller, factory: [:user, :paypal_data], uses_vouchers: true
    end

    trait :with_unified_transport do
      association :seller, factory: [:legal_entity, :paypal_data,
                                     :with_unified_transport_information]
      unified_transport { true }
      unified_transport_provider { 'DHL' }
      unified_transport_price_cents { 300 }
      unified_transport_maximum_articles { 10 }
    end

    trait :with_free_transport_at_40 do
      free_transport_at_price_cents { 4000 }
    end

    trait :with_unified_payment_cash do
      unified_payment { true }
      unified_payment_method { 'cash' }
    end

    trait :with_unified_payment_paypal do
      unified_payment { true }
      unified_payment_method { 'paypal' }
    end

    trait :with_unified_payment_invoice do
      unified_payment { true }
      unified_payment_method { 'invoice' }
    end

    trait :with_unified_payment_cash_on_delivery do
      unified_payment { true }
      unified_payment_method { 'cash_on_delivery' }
    end

    trait :with_unified_payment_bank_transfer do
      unified_payment { true }
      unified_payment_method { 'bank_transfer' }
    end
  end
end
