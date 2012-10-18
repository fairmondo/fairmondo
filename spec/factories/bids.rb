require 'faker'

FactoryGirl.define do
  factory :bid , aliases: [:max_bid] do

    transaction
    price_cents { rand(10000) }
  end
end