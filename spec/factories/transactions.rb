# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transaction do
    max_bid
    type ""
    auction { Auction.all.sample }
    buyer
  end
end
