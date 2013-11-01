# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notice do
    message "MyText"
    open true
    path "testpath"
    user
  end
end
