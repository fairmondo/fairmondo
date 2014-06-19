# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :feedback do
    text { Faker::Lorem.paragraph( rand(7)+1 ) }
    subject { Faker::Lorem.sentence }
    from { Faker::Internet.email }
    to { Faker::Internet.email }
    variety {[:report_article, :get_help ,:send_feedback].sample}
    user

    trait :report_article do
      variety :report_article
      article_id { FactoryGirl.create(:article).id}
    end
  end
end
