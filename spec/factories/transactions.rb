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
    article { FactoryGirl.create :article, :without_build_transaction }
    seller { article.seller }

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
      selected_transport 'pickup'
      selected_payment 'cash'

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
      selected_transport 'pickup'
      selected_payment 'cash'
      purchase_emails_sent true
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
    end


  end
end