require 'faker'

FactoryGirl.define do
  factory :auction, aliases: [:appended_object] do
    seller
    categories_with_parents { Category.all.sample(rand(2)+1).map{|c| c.self_and_ancestors}.flatten.uniq.map(&:id).map(&:to_s) }
    title     { Faker::Lorem.sentence(rand(3)+1).chomp '.' }
    content   { Faker::Lorem.paragraph(rand(7)+1) }
    expire    { (rand(10) + 2).hours.from_now }
    transaction "auction"
    condition { ["new", "old"].sample }
    price_cents { Random.new.rand(500000)+1 }
    quantity  { (rand(10) + 1) }
    transport { [:pickup, :insured, :uninsured].sample(rand(3)+1) }    
    payment   { [:bank_transfer, :cash, :paypal, :cach_on_delivery, :invoice].sample(rand(5)+1) }
  end
end