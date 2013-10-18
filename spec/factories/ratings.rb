# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rating do
    rating { ["positive", "neutral", "negative"].sample }
    text "MyText"
    transaction
    rated_user { transaction.seller }

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
