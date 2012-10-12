require 'faker'

FactoryGirl.define do
  factory :bid do
    user_id :user
    price_cents { rand(10000) }
  end
end