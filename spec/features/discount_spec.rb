require "spec_helper"

describe Discount do
  let( :user ) { FactoryGirl.create :user }
  let( :transaction ) { FactoryGirl.create :single_transaction }
  let( :discount ) { FactoryGirl.create :discount }

  describe 'when buying an article' do
    it 'should apply discount' do
      visit transaction_path( transaction )
      click_button buy
      FastbillAPI.should not_receive setusage_data
    end

    it 'should generate discount card for user' do
      visit transaction_path( transaction )
      click_button buy
      seller.should have discount_card
    end
  end
end
