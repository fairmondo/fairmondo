require 'faker'

FactoryGirl.define do
  factory :user, aliases: [:seller, :buyer, :sender, :follower, :followable] do
    email      { Faker::Internet.email }
    password   'password'
  end
end