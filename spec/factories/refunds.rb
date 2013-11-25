# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :refund do
    refund_reason "MyString"
    refund_explanation "MyString"
  end
end
