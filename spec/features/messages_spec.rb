require 'spec_helper'

include Warden::Test::Helpers

describe 'Private Messages' do

  describe 'NEW page' do

    describe "for signed-out users" do
      it "should show a sign in button" do
        visit new_message_path
        page.should have_content("Login")
      end
    end

    describe "for signed-in users" do
      before :each do
        @user = FactoryGirl.create(:user, forename: 'Foo', surname: 'Bar')
        login_as @user
      end

      describe "when recipient is the current user" do
        it 'should show an error' do
          visit new_message_path(id: @user.id)
          page.should have_content 'keine Nachricht an sich selbst'
        end
      end

      describe "when recipient is a different user" do
        before :each do
          @recipient = FactoryGirl.create(:user, forename: 'Baz', surname: 'Fuz')
          visit new_message_path(id: @recipient.id)
        end

        it 'should show the page' do
          page.should have_content("Neue Nachricht")
        end

        it "should show the recipient's name" do
          page.should have_content('Baz Fuz')
        end

        describe 'form failure' do
          it 'should occur when the form is empty' do
            click_on 'Senden'

            page.should have_content 'alle Felder ausfuellen'
          end

          it 'should occur when the title is missing' do
            fill_in 'Titel:', with: 'Foobar'
            click_on 'Senden'

            page.should have_content 'alle Felder ausfuellen'
          end

          it 'should occur when the content is missing' do
            fill_in 'Inhalt:', with: 'Foobar'
            click_on 'Senden'

            page.should have_content 'alle Felder ausfuellen'
          end
        end

        describe 'form success' do
          it 'should occur when everything has been filled in' do
            fill_in 'Titel:', with: 'MyTitle'
            fill_in 'Inhalt:', with: 'MyContent'
            click_on 'Senden'

            page.should have_content 'MyTitle'
            page.should have_content 'MyContent'
            page.should have_content 'erfolgreich abgeschickt'
          end
        end
      end
    end
  end

  describe 'INDEX page' do
    it 'should have tests' do
      pending
    end
  end

  describe 'VIEW page' do
    it 'should have tests' do
      pending
    end
  end
end
