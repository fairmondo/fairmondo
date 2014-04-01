FactoryGirl.define do
  factory :refund do
    reason :not_in_stock
    description 'ab' * 80
    transaction { FactoryGirl.create :transaction_with_buyer, :old }

    trait :not_sold_transaction do
      transaction { FactoryGirl.create :single_transaction }
    end
  end
end
