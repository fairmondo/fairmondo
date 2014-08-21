# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cart do
    user
  end

  trait :with_line_item_groups do
    ignore do
      line_item_group_count 3
    end

    after(:create) do |cart, evaluator|
      create_list(:line_item_group, evaluator.line_item_group_count, cart: cart)
    end
  end


end
