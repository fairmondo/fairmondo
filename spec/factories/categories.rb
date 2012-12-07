require 'faker'

FactoryGirl.define do
  factory :category do
    name { Faker::Lorem.sentence( rand(3)+1 ).chomp '.' }
    level 0
    parent_id 0
  end
end