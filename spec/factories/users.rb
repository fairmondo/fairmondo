require 'faker'

FactoryGirl.define do
  factory :user, aliases: [:seller, :buyer, :sender, :follower, :followable] do
    after_create { |user| user.confirm! }
    email       { Faker::Internet.email }
    password    'password'
    nickname    { Faker::Internet.user_name }
    surname     { Faker::Name.last_name }
    forename    { Faker::Name.first_name }
    privacy     true
    legal       true
    legal_entity { [true, false].sample }
  end
end