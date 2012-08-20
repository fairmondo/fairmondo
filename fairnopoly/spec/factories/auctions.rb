require 'faker'
FactoryGirl.define do
  factory :auction do
    seller
    category
    title     { Faker::Lorem.sentence( rand 1..3 ).chomp '.' }
    content   { Faker::Lorem.paragraph( rand 1..7 ) }
    condition { ["new", "fair", "old"].sample }
    price_cents { Random.new.rand(1..500000) }
    price_currency "EUR"
  end
end