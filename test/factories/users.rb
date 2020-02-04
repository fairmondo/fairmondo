#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

FactoryBot.define do
  factory :user, aliases: [:seller, :buyer, :sender, :rated_user], class: %w(PrivateUser LegalEntity).sample do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password' }
    sequence(:nickname) { |n| "User #{n}" }
    legal { '1' }

    about_me { Faker::Lorem.paragraph(sentence_count: rand(7) + 1) }
    terms { Faker::Lorem.paragraph(sentence_count: rand(7) + 1) }
    cancellation { Faker::Lorem.paragraph(sentence_count: rand(7) + 1) }
    about { Faker::Lorem.paragraph(sentence_count: rand(7) + 1) }

    confirmed_at { Time.now }

    bank_code { rand(99999999).to_s.center(8, rand(9).to_s) }
    bank_account_number { rand(99999999).to_s.center(8, rand(9).to_s) }
    bank_account_owner { Faker::Name.name }
    bank_name { Faker::Name.name }

    iban { %w(DE AT CH).sample + rand(99999999999999999999).to_s.center(20, rand(9).to_s) }
    bic { %w(ABCDEF ZJFBLO TNAPIT EMLOAB).sample + rand(99).to_s.center(2, rand(9).to_s) }

    direct_debit_exemption { true }
    uses_vouchers { false }
    created_at { 2.month.ago }

    buyer_state { 'standard_buyer' }
    seller_state { :standard_seller }

    unified_transport_provider { 'DHL' }
    unified_transport_price_cents { 2000 }
    unified_transport_maximum_articles { 12 }

    transient do
      create_standard_address { true }
    end

    after(:create) do |user, evaluator|
      if evaluator.create_standard_address
        address = create(:address_with_bike_courier_zip, user: user)
        user.update_attribute(:standard_address_id, address.id)
      end
    end

    trait :missing_bank_data do
      bank_code { '' }
      bank_account_number { '' }
      bank_account_owner { '' }
      bank_name { '' }
      iban { '' }
      bic { '' }
    end

    factory :admin_user do
      admin { true }
    end

    factory :non_german_user do
      country { Faker::Address.country }
    end

    factory :private_user, class: 'PrivateUser' do
    end

    factory :legal_entity, class: 'LegalEntity' do
      seller_state { :standard_seller }
      invoicing_email { 'invoices@example.com' }
      order_notifications_email { 'orders@example.com' }
    end

    factory :ngo, class: 'LegalEntity', traits: [:ngo]

    factory :incomplete_user, class: 'PrivateUser' do
      transient do
        create_standard_address { false }
      end
    end

    trait :no_bank_data do
      bank_code { '' }
      bank_account_number { '' }
      iban { '' }
      bic { '' }
    end

    trait :paypal_data do
      paypal_account { Faker::Internet.email }
    end

    trait :fastbill do
      fastbill_id { '1223' }
      fastbill_subscription_id { '76543' }
    end

    trait :ngo do
      ngo { true }
    end

    trait :marketplace_owner_account do
      marketplace_owner_account { true }
    end

    trait :with_unified_transport_information do
      unified_transport_provider { 'DHL' }
      unified_transport_price_cents { 300 }
      unified_transport_maximum_articles { 10 }
    end

    trait :with_free_transport_at_5 do
      free_transport_at_price_cents { 500 }
      free_transport_available { true }
    end
  end

  # Users Bob and Alice could in the future be used for scenarios etc.
  # Alice is a legal entity, Bob a private user. Maybe invent a third person for admin
  # and a fourth for NGO.
  factory :user_bob, class: PrivateUser do
    nickname { 'bob' }
    email { 'bob@example.com' }
    password { 'password' }
  end

  # Alice is a legal entity and sells fair electronics
  factory :user_alice, class: LegalEntity do
    nickname { 'fairix' }
    email { 'alice@fairix.com' }
    password { 'password' }
    association :standard_address, factory: :address_for_alice

    factory :user_alice_with_bank_details, traits: [:with_bank_details]

    trait :with_bank_details do
      iban { 'DE12500105170648489890' }
      bic { 'GENODEF1JEV' }
      bank_name { 'GLS Gemeinschaftsbank' }
      bank_account_owner { 'Alice Henderson' }
    end
  end

  # Carol is an admin user
  factory :user_carol, class: PrivateUser do
    nickname { 'carol' }
    email { 'carol@example.com' }
    password { 'password' }
    admin { true }
  end

  # Dave is an ngo user
  factory :user_dave, class: LegalEntity do
    nickname { 'greenpeace' }
    email { 'dave@greenpeace.com' }
    password { 'password' }
    ngo { true }
    association :standard_address, factory: :address_for_alice
  end

  # Eve is a marketplace owner user
  factory :user_eve, class: LegalEntity do
    nickname { 'fairmondo-shop' }
    email { 'eve@fairmondo.de' }
    password { 'password' }
    marketplace_owner_account { true }
    association :standard_address, factory: :address_for_alice
  end
end
