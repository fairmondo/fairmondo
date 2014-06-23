# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :line_item_group do
    message "MyText"
    cart_id 1
    tos_accepted false
    user_id 1
    master_line_item_id 1
  end
end
