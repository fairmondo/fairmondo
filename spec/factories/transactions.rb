# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transaction, :class => 'Transaction' do
    auction
    type "PreviewTransaction"
    factory :preview_transaction, :class => 'PreviewTransaction' do
    end

    factory :auction_transaction, :class => 'AuctionTransaction' do
       expire    { (rand(10) + 2).hours.from_now }
    end
  end

end
