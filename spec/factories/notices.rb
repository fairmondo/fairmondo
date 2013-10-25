# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notices do
    message "MyText"
    open true
    user
  end
end
