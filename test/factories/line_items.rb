#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

FactoryBot.define do
  factory :line_item do
    requested_quantity { 1 }
    association :article
    line_item_group { create :line_item_group, seller: article.seller }

    factory :line_item_with_conventional_article, traits: [:with_conventional_article]
    factory :line_item_with_fair_article,         traits: [:with_fair_article]
    factory :line_item_with_private_user,         traits: [:with_private_user]
    factory :line_item_with_legal_entity,         traits: [:with_legal_entity]

    trait :with_conventional_article do
      association :article, factory: [:article, :with_legal_entity], condition: 'new'
    end

    trait :with_fair_article do
      association :article, factory: [:article, :with_legal_entity, :simple_fair], condition: 'new'
    end

    trait :with_private_user do
      association :article, factory: [:article, :with_private_user], condition: 'new'
    end

    trait :with_legal_entity do
      association :article, factory: [:article, :with_legal_entity], condition: 'new'
    end
  end
end
