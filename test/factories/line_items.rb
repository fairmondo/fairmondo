# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :line_item do
    article
    line_item_group

    requested_quantity 1

    factory :line_item_with_specific_seller do
      article { FactoryGirl.create :article_with_business_transaction, seller: line_item_group.seller }
    end
  end
end
