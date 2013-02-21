require 'faker'

FactoryGirl.define do
  factory :bid  do
    auction_transaction
    user
    price_cents { rand(10000) }
  end
end