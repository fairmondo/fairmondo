require 'faker'

FactoryGirl.define do
  factory :category do
    name { Faker::Lorem.sentence( rand 1..3 ).chomp '.' }
    #{ Faker::Lorem.sentence( rand 1..3 ).chomp '.' }
    level 0
    parent_id 0
  end
end