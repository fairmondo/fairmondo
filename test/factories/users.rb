#
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
require 'ffaker'

FactoryGirl.define do
  factory :user, aliases: [:seller, :buyer, :sender, :rated_user] , class: ["PrivateUser", "LegalEntity"].sample do
    email       { Faker::Internet.email }
    password    'password'
    sequence(:nickname) {|n| "#{Faker::Internet.user_name}#{n}" }
    legal       "1"
    agecheck    "1"

    about_me    { Faker::Lorem.paragraph( rand(7)+1 ) }
    terms    { Faker::Lorem.paragraph( rand(7)+1 ) }
    cancellation    { Faker::Lorem.paragraph( rand(7)+1 ) }
    about    { Faker::Lorem.paragraph( rand(7)+1 ) }

    confirmed_at Time.now

    bank_code {rand(99999999).to_s.center(8, rand(9).to_s)}
    bank_account_number {rand(99999999).to_s.center(8, rand(9).to_s)}
    bank_account_owner Faker::Name.name
    bank_name Faker::Name.name

    iban {["DE","AT","CH"].sample+rand(99999999999999999999).to_s.center(20, rand(9).to_s)}
    bic {["ABCDEF","ZJFBLO","TNAPIT","EMLOAB"].sample + rand(99).to_s.center(2, rand(9).to_s)}

    direct_debit true

    seller_state "standard_seller"
    buyer_state "standard_buyer"

    after(:create) do |user|
      address = FactoryGirl.create(:address, user: user)
      user.update_attribute(:standard_address_id, address.id)
    end

    trait :missing_bank_data do
      bank_code ""
      bank_account_number ""
      bank_account_owner ""
      bank_name ""
      iban ""
      bic ""
    end

    factory :admin_user do
      admin       true
    end

    factory :non_german_user do
      country Faker::Address.country
    end

    factory :private_user, class: 'PrivateUser' do
    end

    factory :legal_entity, class: 'LegalEntity' do
    end

    factory :legal_entity_with_fixture_address do
      standard_address { FactoryGirl.create :address, :fixture_address }
    end

    factory :incomplete_user do
      standard_address nil
    end

    factory :seller_with_line_item_groups, parent: :user do
      ignore do
        line_item_groups_count 3
      end

      after(:create) do |user, evaluator|
        create_list(:line_item_group_with_items, evaluator.line_item_groups_count, seller: user)
      end
    end

    factory :buyer_with_line_item_groups, parent: :user do
      ignore do
        line_item_groups_count 3
      end

      after(:create) do |user, evaluator|
        create_list(:line_item_group_with_items, evaluator.line_item_groups_count, buyer: user, tos_accepted: true)
      end
    end

    trait :no_bank_data do
      bank_code ""
      bank_account_number ""
      iban ""
      bic ""
    end

    trait :paypal_data do
      paypal_account Faker::Internet.email
    end

    trait :fastbill do
      fastbill_id '1223'
      fastbill_subscription_id '76543'
    end

    trait :ngo do
      ngo true
    end
  end
end
