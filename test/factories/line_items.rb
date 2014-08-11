# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :line_item do
    article
    line_item_group { FactoryGirl.create :line_item_group, seller: article.seller }

    requested_quantity 1

  end
end
