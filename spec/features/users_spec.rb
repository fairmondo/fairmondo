require 'spec_helper'

include Warden::Test::Helpers

describe 'User management' do

  describe "for non-signed-in users" do

    it "should show a login button" do
      visit root_path
      page.should have_content("Login")
    end

    it "registers a new user" do
      Recaptcha.with_configuration(:public_key => '12345') do
        visit new_user_registration_path
      end
      expect {
        fill_in 'Nickname', with: 'nickname'
        fill_in 'Email', with:    'email@example.com'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        choose 'user_type_legalentity'
        check 'user_legal'
        check 'user_privacy'
        check 'user_agecheck'
        click_button 'sign_up'
        User.find_by_email('email@example.com').confirm!
      }.to change(User, :count).by(1)
    end
  end

  describe "for signed-in users" do

    before :each do
      @user = FactoryGirl.create(:user)
      login_as @user
    end

    it 'should show the dashboard' do
      visit users_path
      page.should have_content("Profile")
    end

    it 'should not show the link to community' do
      visit users_path
      page.should_not have_content("TrustCommunity")
    end
  end

end
