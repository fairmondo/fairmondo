# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :exhibit do
    article
    queue "old"
    trait :expired do
      exhibition_date DateTime.now - 25.hours
    end

    trait :dream_team do
      related_article {FactoryGirl.create(:article)}
      queue "dream_team"
    end
  end
end
