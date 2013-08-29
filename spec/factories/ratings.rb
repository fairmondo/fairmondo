# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rating do
    rating { ["positive", "neutral", "negative"].sample }
    text "MyText"
    transaction_id 1
    rated_user_id 1

    factory :positive_rating do
      rating "positive"
    end

    factory :negative_rating do
      rating "negative"
    end
  end
end
