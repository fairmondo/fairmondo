require 'faker'

FactoryGirl.define do
  factory :bid  do
    auction
    user
    price_cents { rand(10000) }
  end
end