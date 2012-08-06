require 'faker'

FactoryGirl.define do
  factory :ffp do 
    price { Random.new.rand(10..500) }
  end
end