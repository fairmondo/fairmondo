# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rating do
    rating "MyString"
    text "MyText"
    transaction_id 1
    seller_id 1
  end
end
