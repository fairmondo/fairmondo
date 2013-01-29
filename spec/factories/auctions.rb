require 'faker'

FactoryGirl.define do
  factory :auction, aliases: [:appended_object] do
    seller
    categories_with_parents {|c| [c.association(:root_category)] }
    title     { Faker::Lorem.sentence(rand(3)+1).chomp '.' }
    content   { Faker::Lorem.paragraph(rand(7)+1) }
    expire    { (rand(10) + 2).hours.from_now }
    transaction "auction"
    condition { ["new", "old"].sample }
    price_cents { Random.new.rand(500000)+1 }
    quantity  { (rand(10) + 1) }
    transport { Auction.transport.values.sample(rand(3)+1) }    
    payment   { Auction.payment.values.sample(rand(5)+1) }
  end
end