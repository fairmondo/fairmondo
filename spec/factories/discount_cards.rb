# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :discount_card do
    user_id ""
    discount_id ""
    value_cents ""
    num_of_articles 1
  end
end
