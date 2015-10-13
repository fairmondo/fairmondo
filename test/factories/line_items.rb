#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

FactoryGirl.define do
  factory :line_item do
    article
    line_item_group { FactoryGirl.create :line_item_group, seller: article.seller }

    requested_quantity 1
  end

  trait :with_conventional_article do
    article do
      FactoryGirl.create(:article, :with_legal_entity, condition: 'new')
    end
  end

  trait :with_fair_article do
    article do
      FactoryGirl.create(:article, :with_legal_entity, :simple_fair,
                         condition: 'new')
    end
  end
end
