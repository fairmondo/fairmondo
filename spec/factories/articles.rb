require 'faker'

FactoryGirl.define do
  factory :article, aliases: [:appended_object] do
    seller
    categories_and_ancestors {|c| [c.association(:category)] }
    title     { Faker::Lorem.characters(rand(6..65)).chomp '.' }
    content   { Faker::Lorem.paragraph(rand(7)+1) }
    condition { ["new", "old"].sample }
    condition_extra {[:as_good_as_new, :as_good_as_warranted ,:used_very_good , :used_good, :used_satisfying , :broken].sample}
    price_cents { Random.new.rand(500000)+1 }
    quantity  { (rand(10) + 1) }

    basic_price_cents { Random.new.rand(500000)+1 }
    basic_price_amount {[:kilogram, :gram, :liter, :milliliter, :cubicmeter, :meter, :squaremeter, :portion].sample}

    default_transport "pickup"
    transport_pickup true

    transport_details "transport_details"
    default_payment "cash"
    payment_cash true

    payment_details "payment_details"
    after(:build) do |article|
      article.images << FactoryGirl.build(:image,:article => article)
      article.transaction ||= FactoryGirl.build(:preview_transaction,:article => article)
      article.locked = true
      article.active = true
    end

    factory :second_hand_article do
      condition "old"
      condition_extra "as_good_as_new"
    end

    factory :no_second_hand_article do
      condition "new"
    end

    factory :inactive_article do
       after(:build) do |article|
         article.active = false
         article.locked = false
       end
    end

    factory :editable_article do
      after(:build) do |article|
         article.active = false
         article.locked = false
      end
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
  end
end