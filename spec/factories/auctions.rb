require 'faker'

FactoryGirl.define do
  factory :auction, aliases: [:appended_object] do
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
    after(:build) do |auction|
      auction.images << FactoryGirl.build(:image,:auction => auction)
      auction.transaction ||= FactoryGirl.build(:preview_transaction,:auction => auction)
      auction.locked = true
      auction.active = true
    end

    factory :second_hand_auction do
      condition "old"
      condition_extra "as_good_as_new"
    end

    factory :no_second_hand_auction do
      condition "new"
    end

    factory :inactive_auction do
       after(:build) do |auction|
         auction.active = false
         auction.locked = false
       end
    end

    factory :editable_auction do
      after(:build) do |auction|
         auction.active = false
         auction.locked = false
      end
    end

    trait :category1 do
      after(:build) do |auction|
        auction.categories = [Category.find(1)]
      end
    end
    trait :category2 do
      after(:build) do |auction|
        auction.categories = [Category.find(2)]
      end
    end
    trait :category3 do
      after(:build) do |auction|
        auction.categories = [Category.find(3)]
      end
    end
    trait :with_child_category do
      categories_and_ancestors {|c| [c.association(:category), c.association(:child_category)] }
    end
  end
end