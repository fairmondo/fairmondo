# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rating do
    rating { ["positive", "neutral", "negative"].sample }
    text "Dies ist eine Bewertung!"
    business_transaction { FactoryGirl.create :business_transaction_with_buyer }
    rated_user { business_transaction.seller }
    rating_user { business_transaction.buyer }

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
