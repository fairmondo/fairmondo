# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :payment, class: 'PaypalPayment' do
    line_item_group { FactoryGirl.create :line_item_group, :sold, :with_business_transactions, traits: [:paypal, :transport_type1] }

    trait :with_pay_key do
      pay_key 'foobar'
    end
  end
end
