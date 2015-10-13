#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

FactoryGirl.define do
  factory :rating do
    rating { %w(positive neutral negative).sample }
    text 'Die ist eine Bewertung!'
    line_item_group { FactoryGirl.create :line_item_group, :with_business_transactions, :sold }
    rated_user { line_item_group.seller }
    rating_user { line_item_group.buyer }

    factory :positive_rating do
      rating 'positive'
    end

    factory :neutral_rating do
      rating 'neutral'
    end

    factory :negative_rating do
      rating 'negative'
    end
  end
end
