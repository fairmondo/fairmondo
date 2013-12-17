FactoryGirl.define do
  factory :refund do
    reason { [ :refund, :sent_back, :not_in_stock, :not_paid ].sample } 
    description 'a' * 160
    transaction { FactoryGirl.create :transaction_with_buyer, :old }

    trait :not_sold_transaction do
      transaction { FactoryGirl.create :single_transaction }
    end
  end
end
