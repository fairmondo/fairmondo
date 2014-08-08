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
  end

  trait :with_business_transactions do
    ignore do
      articles_attributes [{},{},{}]
      traits [[:cash, :pickup], [:paypal, :transport_type1], [:invoice, :transport_type2]]
    end

    seller { FactoryGirl.create(:seller, :paypal_data) } # that paypal can be selected

    after(:create) do |line_item_group, evaluator|
      evaluator.traits.each_with_index do |traits,index|
        create_list(:business_transaction, 1, *traits, line_item_group: line_item_group, seller: line_item_group.seller, article_attributes: evaluator.articles_attributes[index] || {} )
      end
    end
  end

  trait :sold do
    tos_accepted true
  end

  trait :with_unified_transport do
    unified_transport true
    seller { FactoryGirl.create(:legal_entity, :paypal_data, :with_unified_transport_information) }
    unified_transport_provider 'DHL'
    unified_transport_price_cents 300
    unified_transport_maximum_articles 10
    unified_transport_cash_on_delivery_price_cents '200'
  end

  trait :with_unified_payment_cash do
    unified_payment true
    unified_payment_method 'cash'
  end

  trait :with_unified_payment_paypal do
    unified_payment true
    unified_payment_method 'paypal'
  end

  trait :with_unified_payment_invoice do
    unified_payment true
    unified_payment_method 'invoice'
  end

  trait :with_unified_payment_cash_on_delivery do
    unified_payment true
    unified_payment_method 'cash_on_delivery'
  end

  trait :with_unified_payment_bank_transfer do
    unified_payment true
    unified_payment_method 'bank_transfer'
  end

end
