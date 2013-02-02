# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :auction_template do
    name { Faker::Lorem.words( rand(3)+2 ) * " " }
    auction
    user
  end
end
