# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invoice_item, :class => 'InvoiceItems' do
    invoice_id 1
    article_id 1
    price_cents 1
    calculated_fee_cents 1
    calculated_fair_cents 1
    calculated_friendly_cents 1
    quantity 1
  end
end
