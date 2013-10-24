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
require 'faker'

FactoryGirl.define do
  factory :user, aliases: [:seller, :buyer, :sender] , class: ["PrivateUser", "LegalEntity"].sample do
    email       { Faker::Internet.email }
    password    'password'
    sequence(:nickname) {|n| "#{Faker::Internet.user_name}#{n}" }
    surname     { Faker::Name.last_name }
    forename    { Faker::Name.first_name }
    privacy     "1"
    legal       "1"
    agecheck    "1"
    recaptcha   '1'

    about_me    { Faker::Lorem.paragraph( rand(7)+1 ) }
    terms    { Faker::Lorem.paragraph( rand(7)+1 ) }
    cancellation    { Faker::Lorem.paragraph( rand(7)+1 ) }
    about    { Faker::Lorem.paragraph( rand(7)+1 ) }
    title { Faker::Name.prefix }
    country "Deutschland"
    street { Faker::Address.street_address }
    address_suffix { Faker::Name.last_name }
    city { Faker::Address.city }
    zip { Faker::Address.postcode }

    company_name { self.class == "LegalEntity" ? Faker::Company.name : nil }

    confirmed_at Time.now

    bank_code {rand(99999999).to_s.center(8, rand(9).to_s)}
    bank_account_number {rand(99999999).to_s.center(8, rand(9).to_s)}
    bank_account_owner Faker::Name.name
    bank_name Faker::Name.name

    direct_debit '1'

    trait :missing_bank_data do
      bank_code ""
      bank_account_number ""
      bank_account_owner ""
      bank_name ""
   end

    seller_state "standard_seller"
    buyer_state "standard_buyer"

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

    factory :incomplete_user do
      country nil
    end

    trait :no_bank_data do
      bank_code ""
      bank_account_number ""
    end

    trait :paypal_data do
      paypal_account Faker::Internet.email
    end
  end

end
