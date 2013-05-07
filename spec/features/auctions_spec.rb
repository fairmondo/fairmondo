require 'spec_helper'

include Warden::Test::Helpers

describe 'Auction management' do
  include CategorySeedData

  describe "for signed-in users" do
    before :each do
      @user = FactoryGirl.create(:user)
      login_as @user
    end

    it 'creates an auction' do
      FactoryGirl.create(:category, :parent => nil)
      visit new_auction_path
      page.should have_content("New Auction")
      lambda do
        fill_in 'Title', with: 'Auction title'
        check Category.root.name
        within("#auction_condition_input") do
          choose 'New' 
        end
        if @user.is_a?(LegalEntity)
          fill_in 'auction_basic_price', with: 99.99
          select "kilogram" , from: 'auction_basic_price_amount'
        end
        fill_in 'Content', with: 'Auction content'
        check "auction_transport_pickup"
        select "Pickup" , from: 'Default transport'
        fill_in 'Transport details', with: 'transport_details'
        check "auction_payment_cash"
        select "Cash" , from: 'Default payment'
        fill_in 'Payment details', with: 'payment_details'
        find(".form-actions").find("input").click
      end.should change(Auction.unscoped, :count).by(1)
    end

    it 'creates categories' do
      setup_categories

      visit new_auction_path
      # TODO find out how to test rails asset pipeline visible styles
      # page.should have_content("Hardware", visible: false)
      
      check "auction_categories_and_ancestors_#{Category.find_by_name!('Elektronik').id}"
      check "auction_categories_and_ancestors_#{Category.find_by_name!('Computer').id}"
      page.should have_content("Hardware")
    end
  end
end