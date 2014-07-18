# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :payment do


    trait :with_pay_key do
      pay_key 'foobar'
    end
  end
end
