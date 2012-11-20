require 'faker'

FactoryGirl.define do
  factory :user, aliases: [:seller, :buyer, :sender, :follower, :followable] do
    after_create { |user| user.confirm! }
    email      { Faker::Internet.email }
    password   'password'
  end
end