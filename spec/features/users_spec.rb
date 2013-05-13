require 'spec_helper'

include Warden::Test::Helpers

describe 'User management' do

  context "for signed-out users" do
    it "should show a login button" do
      visit root_path
      page.should have_content("Login")
    end

    it "registers a new user" do
      Recaptcha.with_configuration(:public_key => '12345') do
        visit new_user_registration_path
      end
      expect do
        fill_in 'user_nickname',              with: 'nickname'
        fill_in 'user_email',                 with: 'email@example.com'
        fill_in 'user_password',              with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        choose 'user_type_legalentity'
        check 'user_legal'
        check 'user_privacy'
        check 'user_agecheck'
        click_button 'sign_up'
        User.find_by_email('email@example.com').confirm!
      end.to change(User, :count).by(1)
    end

    it "should sign in a valid user" do
      user = FactoryGirl.create :user
      visit new_user_session_path

      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'password'
      click_button 'Login'

      page.should have_content I18n.t 'devise.sessions.signed_in'
    end

    it "should not sign in a banned user" do
      user = FactoryGirl.create :user, banned: true
      visit new_user_session_path

      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: 'password'
      click_button 'Login'

      page.should_not have_content I18n.t 'devise.sessions.signed_in'
    end
  end

  context "for signed-in users" do
    before :each do
      @user = FactoryGirl.create(:user)
      login_as @user
    end

    describe "user profile page" do
      it "should open" do
        visit profile_user_path @user
        page.status_code.should == 200
      end
    end

    describe "sales page" do
      it "should open" do
        visit sales_user_path @user
        page.status_code.should == 200
      end
    end

    describe "user show page" do
      it 'should show the dashboard' do
        visit users_path
        page.should have_content I18n.t("common.text.profile")
      end

      it 'should not show the link to community' do
        visit users_path
        page.should_not have_content("TrustCommunity")
      end
    end
  end

end
