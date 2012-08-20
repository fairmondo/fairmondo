# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

  User.create(:email => "user@user.com", :password => "password", :password_confirmation => "password")

  Category.create(:name => "Fahrzeuge", :desc => "", :level => 0, :parent_id => 0)
  Category.create(:name => "Elektronik", :desc => "", :level => 0, :parent_id => 0)
  Category.create(:name => "Haus & Garten", :desc => "", :level => 0, :parent_id => 0)
  Category.create(:name => "Freizeit & Hobby", :desc => "", :level => 0, :parent_id => 0)
  Category.create(:name => "Computer", :desc => "", :level => 1, :parent_id => 2)
  Category.create(:name => "Audio & HiFi ", :desc => "", :level => 1, :parent_id => 2)
  Category.create(:name => "Hardware", :desc => "", :level => 2, :parent_id => 5)
  Category.create(:name => "Software", :desc => "", :level => 2, :parent_id => 5)

50.times do
  FactoryGirl.create(:auction, :category_id => Category.all.sample.id)
  FactoryGirl.create(:bid, :user_id => User.all.sample.id, :auction => Auction.all.sample)
  FactoryGirl.create(:ffp, :user_id => User.all.sample.id)
  FactoryGirl.create(:invitation, :user_id => User.all.sample.id)
end
