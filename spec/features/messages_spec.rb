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
        @user = FactoryGirl.create :user
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

          it 'should occur when the content is missing' do
            fill_in 'Titel:', with: 'Foobar'
            click_on 'Senden'

            page.should have_content 'alle Felder ausfuellen'
          end

          it 'should occur when the title is missing' do
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
    describe "for signed-out users" do
      it "should show a sign in button" do
        visit messages_path
        page.should have_content("Login")
      end
    end

    describe "for signed-in users" do
      before :each do
        @user = FactoryGirl.create :user
        login_as @user
        visit messages_path
      end

      it "should have a title" do
        page.should have_css('h1', text:'Meine Nachrichten')
      end

      describe "the inbox" do
        describe "being empty" do
          it "should have an approproate note" do
            page.should have_content('Inbox: Keine Nachrichten vorhanden')
          end
        end
        describe "having content" do
          before(:each) do
            @message = FactoryGirl.create(:message, message_recipient: @user)
            visit messages_path
          end

          it "should display the message's title as a link" do
            page.should have_css('a', text: @message.title)
          end

          it "should link to the message's show page" do
            click_on @message.title
            current_path.should eq(message_path(@message))
          end
        end
      end

      describe "the outbox" do
        describe "being empty" do
          it "should have an appropriate note" do
            page.should have_content('Outbox: Keine Nachrichten vorhanden')
          end
        end

        describe "having content" do
          before(:each) do
            @message = FactoryGirl.create(:message, message_sender: @user)
            visit messages_path
          end

          it "should display the message's title as a link" do
            page.should have_css('a', text: @message.title)
          end

          it "should link to the message's show page" do
            click_on @message.title
            current_path.should eq(message_path(@message))
          end
        end
      end
    end
  end

  describe 'VIEW page' do
    describe "for signed-out users" do
      it "should show a sign in button" do
        visit message_path FactoryGirl.create :message
        page.should have_content("Login")
      end
    end

    describe "for signed-in users" do
      before :each do
        @user = FactoryGirl.create :user
        login_as @user
      end

      describe "being the recipient" do
        before(:each) do
          @message = FactoryGirl.create :message, message_recipient: @user
          visit message_path @message
        end

        it "should have the right title" do
          page.should have_css('h1', text:'Empfangene Nachricht')
        end

        it "should show the sender" do
          page.should have_content("Von: #{@message.message_sender.fullname}")
        end

        it "should link to the sender" do
          click_on @message.message_sender.fullname
          current_path.should eq dashboard_path(@message.message_sender)
        end

        it "should show the message title" do
          page.should have_content(@message.title)
        end

        it "should show the message body" do
          page.should have_content(@message.content)
        end
      end

      describe "being the sender" do
        before(:each) do
          @message = FactoryGirl.create :message, message_sender: @user
          visit message_path @message
        end

        it "should have the right title" do
          page.should have_css('h1', text:'Gesendete Nachricht')
        end

        it "should show the sender" do
          page.should have_content("An: #{@message.message_recipient.fullname}")
        end

        it "should link to the sender" do
          click_on @message.message_recipient.fullname
          current_path.should eq dashboard_path(@message.message_recipient)
        end

        it "should show the message title" do
          page.should have_content(@message.title)
        end

        it "should show the message body" do
          page.should have_content(@message.content)
        end
      end
    end
  end
end
