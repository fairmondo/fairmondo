# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :line_item_group do
    cart
    seller
    buyer
    message "MyText"
    tos_accepted false
    transport_address { buyer.standard_address }
    payment_address { FactoryGirl.create :address, user_id: buyer.id }

    factory :line_item_group_with_items do
      ignore do
        business_transaction_count 3
        line_item_article { FactoryGirl.create :article } # careful: might not set quantity_available right
        traits []
      end

      seller { line_item_article ? line_item_article.seller : FactoryGirl.create(:seller) }

      after(:create) do |line_item_group, evaluator|
        create_list(:business_transaction_with_line_items, evaluator.business_transaction_count, *evaluator.traits, line_item_group: line_item_group, article: evaluator.line_item_article)
      end
    end
  end

  trait :sold do
    tos_accepted true
  end

  trait :with_unified_transport do
    unified_transport true
  end

  trait :with_unified_payment do
    unified_payment true
  end

  trait :cash do
    unified_payment true
    unified_payment_method 'cash'
  end

  trait :paypal do
    unified_payment true
    unified_payment_method 'paypal'
  end

  trait :invoice do
    unified_payment true
    unified_payment_method 'invoice'
  end

  trait :cash_on_delivery do
    unified_payment true
    unified_payment_method 'cash_on_delivery'
  end

  trait :bank_transfer do
    unified_payment true
    unified_payment_method 'bank_transfer'
  end

  trait :with_unified_transport_and_payment do
    unified_transport true
    unified_payment true
  end

  trait :sold_with_items do

  end

end
