#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

FactoryGirl.define do
  factory :private_user, aliases: [:user, :seller] do
    sequence(:nickname) { |n| "user_#{n}" }
    sequence(:slug) { |n| "user_#{n}" }
    sequence(:email) { |n| "user_#{n}@google.com" }
    password 'password'

    factory :admin_user,                  traits: [:admin, :confirmed]
    factory :private_user_with_address,   traits: [:with_address]
    factory :private_user_with_bank_data, traits: [:with_bank_data]
    factory :confirmed_private_user,      traits: [:confirmed]
    factory :regular_private_user,        traits: [:regular, :confirmed, :with_bank_data]

    trait :regular do
      created_at { 2.months.ago }
    end

    trait :confirmed do
      confirmed_at { Time.now }
    end

    trait :with_address do
      association :standard_address, factory: :address_with_bike_courier_zip
    end

    trait :with_bank_data do
      bank_code '50010517'
      bank_account_number '0648489890'
      bank_account_owner 'Erika Mustermann'
      bank_name 'ING-DiBa'
      iban 'DE12500105170648489890'
      bic 'INGDDEFFXXX'
    end

    trait :with_paypal_account do
      paypal_account 'user_paypal@whatever.com'
    end

    trait :with_unified_transport_information do
      unified_transport_provider 'DHL'
      unified_transport_price_cents 300
      unified_transport_maximum_articles 10
    end

    trait :with_free_transport_at_5 do
      free_transport_at_price_cents 500
      free_transport_available true
    end

    trait :admin do
      admin true
    end

    factory :legal_entity, class: LegalEntity do
      factory :legal_entity_that_can_sell,
              traits: [:with_legal_information, :with_direct_debit_authorization, :with_address,
                       :with_bank_data, :confirmed]
      factory :legal_entity_with_address,        traits: [:with_address]
      factory :legal_entity_with_bank_data,      traits: [:with_bank_data]
      factory :legal_entity_with_paypal_account, traits: [:with_paypal_account]
      factory :legal_entity_with_paypal_and_unified_transport,
              traits: [:with_paypal_account, :with_unified_transport_information]
      factory :legal_entity_with_all_data,
              traits: [:with_address, :with_bank_data, :with_paypal_account, :with_fastbill_profile,
                       :with_unified_transport_information, :confirmed]
      factory :ngo,                              traits: [:ngo]
      factory :ngo_with_bank_data,               traits: [:ngo, :with_bank_data]

      trait :ngo do
        ngo true
      end

      trait :with_legal_information do
        about 'I am what you designed me to be. I am your blade. You cannot now complain if you '\
          'also feel the hurt.'
        terms 'We changed again, and yet again, and it was now too late and too far to go back, '\
          'and I went on. And the mists had all solemnly risen now, and the world lay spread '\
          'before me.'
        cancellation 'I have been bent and broken, but - I hope - into a better shape.'
      end

      trait :with_direct_debit_authorization do
        direct_debit true
      end

      trait :with_fastbill_profile do
        fastbill_id '1223'
        fastbill_subscription_id '76543'
      end
    end
  end
  #   legal '1'

  #   about_me    { Faker::Lorem.paragraph(rand(7) + 1) }

  #   uses_vouchers false

  #   seller_state 'standard_seller'
  #   buyer_state 'standard_buyer'
end
