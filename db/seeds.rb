# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

require_relative 'fixtures/category_seed_data.rb'
include CategorySeedData

# skip the devise mailer callback
[User, Auction, Ffp].each do |model|
  model.skip_callback(:create, :after, :send_on_create_confirmation_instructions)
end

admin = FactoryGirl.create(:admin_user, :email => "admin@admin.com", :password => "password", :password_confirmation => "password", :trustcommunity => true)
user = FactoryGirl.create(:user, :email => "user@user.com", :password => "password", :password_confirmation => "password")

setup_categories

50.times do
  FactoryGirl.create(:auction)
  FactoryGirl.create(:ffp, :user_id => User.all.sample.id)
  FactoryGirl.create(:invitation, :user_id => User.all.sample.id)
  FactoryGirl.create(:follow, :followable_id => User.all.sample.id, :followable_type => "User", :follower_id => User.all.sample.id, :follower_type => "User")
end
