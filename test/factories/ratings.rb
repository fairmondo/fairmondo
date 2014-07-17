# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rating do
    rating { ["positive", "neutral", "negative"].sample }
    text "Die ist eine Bewertung!"
    line_item_group { FactoryGirl.create :line_item_group_with_items, :sold }
    rated_user { line_item_group.seller }
    rating_user { line_item_group.buyer }

    factory :positive_rating do
      rating "positive"
    end

    factory :neutral_rating do
      rating "neutral"
    end

    factory :negative_rating do
      rating "negative"
    end
  end
end
