FactoryGirl.define do
  factory :refund do
    reason :not_in_stock
    description 'ab' * 80
    business_transaction { FactoryGirl.create :business_transaction, :old }
  end
end
