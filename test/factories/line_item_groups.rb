# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :line_item_group do
    cart
    seller
    buyer
    message "MyText"
    tos_accepted false
  end

  factory :line_item_group_with_items, parent: :line_item_group do
    ignore do
      line_item_count 3
    end

    after(:create) do |line_item_group, evaluator|
      create_list(:line_item, evaluator.line_item_count, line_item_group: line_item_group)
    end
  end

  trait :sold do
    tos_accepted true
  end

  trait :with_unified_transport do
    unified_transport true
  end

  trait :with_unified_payment do
    unified_payment true
  end

  trait :with_unified_transport_and_payment do
    unified_transport true
    unified_payment true
  end

  trait :sold_with_items do

  end

end
