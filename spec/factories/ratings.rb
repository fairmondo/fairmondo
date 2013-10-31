# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rating do
    rating { ["positive", "neutral", "negative"].sample }
    text "Die ist eine Bewertung!"
    transaction { FactoryGirl.create :transaction_with_buyer }
    rated_user { transaction.seller }
    rating_user { transaction.buyer }

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
