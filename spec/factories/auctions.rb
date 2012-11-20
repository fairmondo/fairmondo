require 'faker'

FactoryGirl.define do
  factory :auction, aliases: [:appended_object] do
    seller
    category
    title     { Faker::Lorem.sentence( rand(3)+1 ).chomp '.' }
    content   { Faker::Lorem.paragraph( rand(7)+1 ) }
    expire    { (rand(1..10) + 2).hours.from_now }
    transaction "auction"
    condition { ["new", "fair", "old"].sample }
    price_cents { Random.new.rand(1..500000) }
    price_currency "EUR"
  end
end