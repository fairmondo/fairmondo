require 'faker'

FactoryGirl.define do
  factory :ffp do 
    price       { Random.new.rand(10..500) }
    name        { Faker::Name.last_name}
    surname     { Faker::Name.first_name}
    email       { Faker::Internet.email }
    created_at  { Time.now }
    updated_at  { Time.now }
    user_id     :user
    activated   { "true" }
  end
end