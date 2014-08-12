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

    ignore do
      sold { false }
      articles { [ FactoryGirl.create(:article, seller: seller) ] }
    end

    after(:create) do |line_item_group, evaluator|
      evaluator.articles.each do |article|
        line_item_group.line_items << FactoryGirl.create(:line_item, article: article, line_item_group: line_item_group)
      end
    end

  end

  trait :with_business_transactions do
    ignore do
      articles_attributes []
      articles {[]} #dont override
      create_line_items false
      traits [[:paypal, :transport_type1], [:invoice, :transport_type2]]
      build_or_create_bts { sold ? :create : :build }
    end

    seller { FactoryGirl.create(:seller, :paypal_data) } # that paypal can be selected

    after(:create) do |line_item_group, evaluator|
      evaluator.traits.each_with_index do |traits,index|
        bt = line_item_group.business_transactions.send(evaluator.build_or_create_bts, FactoryGirl.attributes_for(:business_transaction, *traits, line_item_group: line_item_group, seller: line_item_group.seller, article_attributes: evaluator.articles_attributes[index] || {} ))
        line_item_group.line_items << FactoryGirl.create(:line_item, article: bt.article) if evaluator.create_line_items
      end

    end

  end

  trait :sold do
    ignore do
      sold { true }
    end
    tos_accepted true
  end

  trait :with_unified_transport do
    seller { FactoryGirl.create(:legal_entity, :paypal_data, :with_unified_transport_information) }
    unified_transport true
    unified_transport_provider 'DHL'
    unified_transport_price_cents 300
    unified_transport_maximum_articles 10
  end

  trait :with_free_transport_at_40 do
    free_transport_at_price_cents 4000
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
