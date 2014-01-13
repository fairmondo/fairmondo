# Read about factories at https://github.com/thoughtbot/factory_girl
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
  factory :transaction, class: ['PreviewTransaction', 'SingleFixedPriceTransaction'].sample do
    article { FactoryGirl.create :article, :without_build_transaction, :with_all_transports }
    seller { article.seller }
    selected_transport 'pickup'
    selected_payment 'cash'
    forename { Faker::Name.first_name }
    surname  { Faker::Name.last_name }
    street   { Faker::Address.street_address }
    city     { Faker::Address.city }
    zip      { Faker::Address.postcode }
    country  "Deutschland"
    sold_at { Time.now }
    factory :super_transaction, class: 'Transaction' do
    end

    factory :preview_transaction, class: 'PreviewTransaction' do
    end

    factory :single_transaction, class: 'SingleFixedPriceTransaction' do
      forename { Faker::Name.first_name }
      surname  { Faker::Name.last_name }
      street   { Faker::Address.street_address }
      city     { Faker::Address.city }
      zip      { Faker::Address.postcode }
      country  "Deutschland"
      quantity_bought 1
    end

    factory :multiple_transaction, class: 'MultipleFixedPriceTransaction' do
      article { FactoryGirl.create :article, :without_build_transaction, quantity: 50 }
      quantity_available 50
    end

    factory :partial_transaction, class: 'PartialFixedPriceTransaction' do
      buyer
      parent { FactoryGirl.create :multiple_transaction, quantity_available: 49 }
      quantity_bought 1
      forename { Faker::Name.first_name }
      surname  { Faker::Name.last_name }
      street   { Faker::Address.street_address }
      city     { Faker::Address.city }
      zip      { Faker::Address.postcode }
      country  "Deutschland"
    end

    trait :sold do
      buyer
      state 'sold'
      sold_at { Time.now }
    end

    #factory :auction_transaction, :class => 'AuctionTransaction' do
    #   expire    { (rand(10) + 2).hours.from_now }
    #end

    trait :legal_transaction do
      article { FactoryGirl.create :article, :with_legal_entity, :without_build_transaction}
    end

    trait :private_transaction do
      article { FactoryGirl.create :article, :with_private_user, :without_build_transaction}
    end

    factory :transaction_with_buyer, class: 'SingleFixedPriceTransaction' do
      buyer { FactoryGirl.create :buyer }
      quantity_bought 1
      state 'sold'
      sold_at { Time.now }
      article { FactoryGirl.create :article, :without_build_transaction,:with_all_transports, state: "sold" }
    end

    factory :transaction_with_friendly_percent_and_buyer, class: 'SingleFixedPriceTransaction'  do
      buyer { FactoryGirl.create :buyer }
       quantity_bought 1
      article { FactoryGirl.create :article, :with_friendly_percent}
    end

    #TODO please use transaction_with_buyer
    factory :transaction_with_friendly_percent_missing_bank_data_and_buyer, class: 'SingleFixedPriceTransaction'  do
      buyer { FactoryGirl.create :buyer }
       quantity_bought 1
      article { FactoryGirl.create :article, :with_friendly_percent_and_missing_bank_data}
    end

    trait :incomplete do
       forename {nil}
    end

    trait :bought_nothing do
       quantity_bought 0
    end

    trait :transport_type_1_selected do
      selected_transport :type1
    end

    trait :transport_type_2_selected do
      selected_transport :type2
    end

    trait :cash_on_delivery_selected do
      selected_payment :cash_on_delivery
    end

    trait :fastbill_profile do
      seller { FactoryGirl.create :seller, fastbill_id: rand(1...1000), fastbill_subscription_id: rand(1...1000) }
    end

    trait :old do
      sold_at { 17.days.ago }
    end
  end
end