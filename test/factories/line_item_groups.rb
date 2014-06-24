# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :line_item_group do
    cart
    user

    message "MyText"
    tos_accepted false
    master_line_item_id 1
  end
end
