# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :line_item do
    article
    line_item_group { FactoryGirl.create :line_item_group, seller: article.seller }

    requested_quantity 1
  end

  trait :with_conventional_article do
    article {
      FactoryGirl.create(:article, :with_legal_entity, condition: 'new')
    }
  end

  trait :with_fair_article do
    article {
      FactoryGirl.create(:article, :with_legal_entity, :simple_fair,
                         condition: 'new')
    }
  end
end
