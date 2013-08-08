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
  factory :article, aliases: [:appended_object] do
    seller      # alias for User -> see spec/factories/users.rb
    categories_and_ancestors {|c| [c.association(:category)] }
    title     { Faker::Lorem.characters(rand(6..65)).chomp '.' }
    content   { Faker::Lorem.paragraph(rand(7)+1) }
    condition { ["new", "old"].sample }
    condition_extra {[:as_good_as_new, :as_good_as_warranted, :used_very_good, :used_good, :used_satisfying, :broken].sample}
    price_cents { Random.new.rand(500000)+1 }
    vat {[7,19].sample}
    quantity  { (rand(10) + 1) }

    basic_price_cents { Random.new.rand(500000)+1 }
    basic_price_amount {[:kilogram, :gram, :liter, :milliliter, :cubicmeter, :meter, :squaremeter, :portion].sample}

    default_transport "pickup"
    transport_pickup true

    transport_details "transport_details"
    payment_cash true

    payment_details "payment_details"
    after(:build) do |article|
      article.images << FactoryGirl.build(:image)
      article.transaction ||= FactoryGirl.build(:preview_transaction, article: article)
      article.activate
    end

    factory :second_hand_article do
      condition "old"
      condition_extra "as_good_as_new"
    end

    factory :no_second_hand_article do
      condition "new"
    end

    factory :preview_article do
       after(:build) do |article|
         article.state = "preview"
       end
    end

    factory :social_production do

      fair true
      fair_kind :social_producer
      association :social_producer_questionnaire

    end

    factory :fair_trust do
      fair true
      fair_kind :fair_trust
      association :fair_trust_questionnaire
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
      categories_and_ancestors {|c| [c.association(:category), c.association(:child_category)] }
    end
    trait :with_3_categories do # This should fail validation, so only use with FactoryGirl.build
      categories_and_ancestors {|c| [c.association(:category), c.association(:category), c.association(:category)] }
    end

    trait :without_image do
      after(:build) do |article|
        article.images = []
      end
    end

    trait :with_fixture_image do
      after(:build) do |article|
        article.images = [FactoryGirl.build(:fixture_image)]
      end
    end


    trait :with_all_transports do
      transport_insured true
      transport_uninsured true
      transport_insured_price 20
      transport_uninsured_price 10
      transport_insured_provider 'DHL'
      transport_uninsured_provider 'Hermes'
    end

    trait :with_private_user do
      seller { FactoryGirl.create :private_user }
    end

    trait :simple_fair do
      fair true
      fair_kind :fair_seal
      fair_seal :trans_fair
    end

    trait :simple_ecologic do
      ecologic true
      ecologic_kind :ecologic_seal
      ecologic_seal :bio_siegel
    end

    trait :simple_small_and_precious do
      small_and_precious true
      small_and_precious_eu_small_enterprise true
      small_and_precious_reason "a"*151
    end

  end
end
