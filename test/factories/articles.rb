#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

FactoryBot.define do
  factory :article do
    association :seller, factory: :user
    categories { |c| [c.association(:category)] }
    sequence(:title) { |n| "Book #{n}" }
    content { 'Content of the book' }
    condition { :new }
    price_cents { 3995 }
    vat { 19 }
    quantity { 1 }
    state { 'active' }

    trait :no_vat do
      vat { 0 }
    end

    trait :reduced_vat do
      vat { 7 }
    end

    trait :index_article do
      after :create do |article, _evaluator|
        Indexer.index_article article
      end
    end

    basic_price_cents { 50000 }
    basic_price_amount { :kilogram }

    before :create do |article, _evaluator|
      article.calculate_fees_and_donations
    end

    transport_type1 { true }
    transport_type1_provider { 'DHL Päckchen' }
    transport_type1_price_cents { 400 }
    transport_details { 'transport_details' }
    payment_bank_transfer { true }

    payment_details { 'payment_details' }

    factory :article_template do
      article_template_name { 'book template' }
      state { 'template' }
    end

    factory :second_hand_article do
      condition { :old }
      condition_extra { :as_good_as_new }
    end

    factory :no_second_hand_article do
      condition { :new }
    end

    factory :preview_article do
      after(:build) do |article|
        article.state = 'preview'
      end
    end

    factory :closed_article do
      after(:build) do |article|
        article.state = 'closed'
      end
    end

    factory :locked_article do
      after(:build) do |article|
        article.state = 'locked'
      end
    end

    factory :social_production do
      fair { true }
      fair_kind { :social_producer }
      association :social_producer_questionnaire
    end

    factory :fair_trust do
      fair { true }
      fair_kind { :fair_trust }
      association :fair_trust_questionnaire
    end

    factory :article_with_business_transaction do
      after :create do |article, _evaluator|
        create :business_transaction, article: article
      end
    end

    trait :category1 do
      after(:build) do |article|
        article.categories = [Category.find(1)]
      end
    end

    trait :category2 do
      after(:build) do |article|
        article.categories = [Category.find(2)]
      end
    end

    trait :category3 do
      after(:build) do |article|
        article.categories = [Category.find(3)]
      end
    end

    trait :with_child_category do
      categories { |c| [c.association(:category), c.association(:child_category)] }
    end

    trait :with_3_categories do # This should fail validation, so only use with build
      categories { |c| [c.association(:category), c.association(:category), c.association(:category)] }
    end

    trait :with_fixture_image do
      after(:build) do |article|
        article.images = [build(:article_fixture_image)]
      end
    end

    trait :with_all_transports do
      transport_pickup { true }
      transport_bike_courier { true }
      transport_type1 { true }
      transport_type2 { true }
      transport_type1_price { 20 }
      transport_type2_price { 10 }
      transport_type1_provider { 'DHL' }
      transport_type2_provider { 'Hermes' }
      transport_type1_number { 3 }
      transport_type2_number { 4 }
      transport_bike_courier_number { 5 }
      unified_transport { true }
      transport_details { 'Some transport details' }
    end

    trait :with_all_payments do
      payment_bank_transfer { true }
      payment_cash { true }
      payment_paypal { true }
      payment_cash_on_delivery { true }
      payment_cash_on_delivery_price { 5 }
      payment_invoice { true }
      payment_voucher { true }
      payment_details { 'Some payment details' }

      association :seller, factory: [:user, :paypal_data]
    end

    trait :with_private_user do
      association :seller, factory: [:private_user, :paypal_data]
    end

    trait :with_legal_entity do
      association :seller, factory: [:legal_entity, :paypal_data]
    end

    trait :with_ngo do
      association :seller, factory: [:legal_entity, :paypal_data], ngo: true
    end

    trait :with_friendly_percent do
      friendly_percent { 75 }
      association :friendly_percent_organisation, factory: :legal_entity, ngo: true
    end

    trait :with_friendly_percent_and_missing_bank_data do
      friendly_percent { 75 }
      association :friendly_percent_organisation, factory: [:legal_entity, :missing_bank_data],
                                                  ngo: true
    end

    trait :simple_fair do
      fair { true }
      fair_kind { :fair_seal }
      fair_seal { :trans_fair }
    end

    trait :simple_ecologic do
      ecologic { true }
      ecologic_kind { :ecologic_seal }
      ecologic_seal { :bio_siegel }
    end

    trait :simple_small_and_precious do
      small_and_precious { true }
      small_and_precious_eu_small_enterprise { true }
      small_and_precious_reason do
        'This is a so-called small and precious article because it was '\
        'manufactured in small quantities by people who work largely by hand in small factories '\
        'using traditional methods.'
      end
    end

    trait :with_larger_quantity do
      quantity { 100 }
    end

    trait :with_custom_seller_identifier do
      custom_seller_identifier { 'CUSTOM-004' }
    end

    trait :with_discount do
      association :discount
    end

    trait :invalid do
      title { '' }
    end
  end
end
