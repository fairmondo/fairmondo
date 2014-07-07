# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :line_item do
    article
    line_item_group

    requested_quantity 1
  end
end
