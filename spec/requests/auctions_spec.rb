require 'spec_helper'

include Warden::Test::Helpers

describe 'Auction management' do

  describe "for signed-in users" do
    before :each do
      @user = FactoryGirl.create(:user)
      login_as @user
    end

    it 'creates an auction' do
      FactoryGirl.create(:category)
      visit new_auction_path
      page.should have_content("New Auction")
      lambda do
        click_button Category.all.sample.name
        fill_in 'Title', with: 'Auction title'
        choose 'New'
        fill_in 'Content', with: 'Auction content'
        fill_in 'Price', with: 10
        click_button "Create Auction"
      end.should change(Auction, :count).by(1)
    end

    it 'creates categories' do
      Category.create(:name => "Fahrzeuge", :desc => "", :level => 0, :parent_id => 0)
      Category.create(:name => "Elektronik", :desc => "", :level => 0, :parent_id => 0)
      Category.create(:name => "Haus & Garten", :desc => "", :level => 0, :parent_id => 0)
      Category.create(:name => "Freizeit & Hobby", :desc => "", :level => 0, :parent_id => 0)
      Category.create(:name => "Computer", :desc => "", :level => 1, :parent_id => 2)
      Category.create(:name => "Audio & HiFi ", :desc => "", :level => 1, :parent_id => 2)
      Category.create(:name => "Hardware", :desc => "", :level => 2, :parent_id => 5)
      Category.create(:name => "Software", :desc => "", :level => 2, :parent_id => 5)

      visit new_auction_path
      click_on 'Elektronik'
      click_on 'Computer'
      page.should have_content("Hardware")
    end
  end
end