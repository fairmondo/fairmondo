require 'faker'

FactoryGirl.define do
  factory :follow do
    follower
    followable
  end
end