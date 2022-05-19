#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

FactoryBot.define do
  factory :address do
    first_name { 'Erika' }
    last_name { 'Mustermann' }
    address_line_1 { 'Heidestraße 17' }
    zip { '51147' }
    city { 'Köln' }
    country { 'Deutschland' }

    factory :address_with_bike_courier_zip, traits: [:with_bike_courier_zip]

    trait :with_bike_courier_zip do
      address_line_1 { 'Eldenaer Straße 17' }
      zip { '10247' }
      city { 'Berlin' }
    end
  end

  factory :address_for_alice, class: Address do
    title { 'Frau' }
    company_name { 'Fairix eG' }
    first_name { 'Alice' }
    last_name { 'Henderson' }
    address_line_1 { 'Heidestraße 17' }
    address_line_2 { 'c/o Fairix eG' }
    zip { '51147' }
    city { 'Köln' }
    country { 'Deutschland' }
  end
end
