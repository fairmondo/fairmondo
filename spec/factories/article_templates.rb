# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :article_template do
    name { Faker::Lorem.words( rand(3)+2 ) * " " }
    article
    user
  end
end
