# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :line_item_group do
    cart
    seller
    message "MyText"
    tos_accepted false
  end
end
