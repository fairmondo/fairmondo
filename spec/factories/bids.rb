require 'faker'

FactoryGirl.define do
  factory :bid do
    amount { Random.new.rand(1..500) }
    user
    auction
  end
end