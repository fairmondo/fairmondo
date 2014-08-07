require_relative '../test_helper'

def abacus_for traits
  @line_item_group = FactoryGirl.create :line_item_group, :with_business_transactions, traits: traits
  @abacus = Abacus.new @line_item_group
end

describe 'Abacus' do
  let(:abacus) { }

  it 'calculates a total price with pickup and cash that is the retail price of the articles' do
    abacus_for([[:pickup,:cash]])
    @abacus.total.must_equal @line_item_group.business_transactions.first.article.price * @line_item_group.business_transactions.first.quantity_bought
  end

  it 'calculates a total price with pickup and cash that is the retail price of the articles' do
    abacus_for([[:paypal,:transport_type1],[:paypal,:transport_type2],[:invoice,:transport_type1])
    @abacus.total.must_equal @line_item_group.business_transactions.first.article.price * @line_item_group.business_transactions.first.quantity_bought
  end





end