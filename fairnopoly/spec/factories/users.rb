require 'faker'

FactoryGirl.define do
  factory :user, aliases: [:seller] do
    email      { Faker::Internet.email }
    password   'password'
  end
end