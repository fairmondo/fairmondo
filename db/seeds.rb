# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

# skip the devise mailer callback
[User, Auction, Ffp].each do |model|
  model.skip_callback(:create, :after, :send_on_create_confirmation_instructions)
end

admin = FactoryGirl.create(:admin_user, :email => "admin@admin.com", :password => "password", :password_confirmation => "password")
user = FactoryGirl.create(:user, :email => "user@user.com", :password => "password", :password_confirmation => "password")

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
  FactoryGirl.create(:ffp, :user_id => User.all.sample.id)
  FactoryGirl.create(:invitation, :user_id => User.all.sample.id)
  FactoryGirl.create(:follow, :followable_id => User.all.sample.id, :followable_type => "User", :follower_id => User.all.sample.id, :follower_type => "User")
end
