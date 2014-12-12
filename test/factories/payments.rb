# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :payment, aliases: [:paypal_payment], class: 'PaypalPayment' do
    line_item_group { FactoryGirl.create :line_item_group, :sold, :with_business_transactions, traits: [:paypal, :transport_type1] }

    trait :with_pay_key do
      pay_key 'foobar'
    end

    factory :voucher_payment, class: 'VoucherPayment' do
      line_item_group do
        FactoryGirl.create :line_item_group, :sold, :with_business_transactions,
                            traits: [:voucher, :transport_type1],
                            seller: FactoryGirl.create(:seller, :paypal_data, uses_vouchers: true)
      end

      sequence(:pay_key) { |n| "20abc#{n}" }
    end
  end
end
