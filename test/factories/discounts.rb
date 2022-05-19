#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

FactoryBot.define do
  factory :discount do
    title { 'Discount' }
    description { 'This is a discount' }
    start_time { 15.days.ago }
    end_time { 10.days.from_now }
    percent { 50 }
    max_discounted_value_cents { 5000 }
    num_of_discountable_articles { 10 }

    factory :small_discount, traits: [:small]
    factory :big_discount,   traits: [:big]

    trait :small do
      max_discounted_value_cents { 1 }
    end

    trait :big do
      percent { 100 }
      max_discounted_value_cents { 20000 }
    end
  end
end
