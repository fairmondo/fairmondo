#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

FactoryBot.define do
  factory :rating do
    rating { 'positive' }
    association :line_item_group, :with_business_transactions, :sold
    rated_user { line_item_group.seller }

    factory :positive_rating,  traits: [:positive]
    factory :neutral_rating,   traits: [:neutral]
    factory :negative_rating,  traits: [:negative]
    factory :rating_with_text, traits: [:with_text]

    trait :positive do
      rating { 'positive' }
    end

    trait :negative do
      rating { 'negative' }
    end

    trait :neutral do
      rating { 'neutral' }
    end

    trait :with_text do
      text { 'Ask no questions, and you\'ll be told no lies.' }
    end
  end
end
