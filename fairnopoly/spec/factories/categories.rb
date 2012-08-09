require 'faker'

FactoryGirl.define do
  factory :category do
    name { Faker::Lorem.sentence( rand 1..3 ).chomp '.' }
  end
end