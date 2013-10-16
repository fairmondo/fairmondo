require 'spec_helper'

include Warden::Test::Helpers

describe "Contents" do
  let(:content) { FactoryGirl.create :content }
  let(:admin) { FactoryGirl.create :admin_user }

  describe "#show" do
    context "for an existing page" do
      it "should show the content's body" do
        visit content_path content
        page.should have_content content.body
      end
    end

    context "for a non-existing page" do
      context "being an admin" do
        before { login_as admin }

        it "should forward to the new page" do
          visit content_path 'not-there'
          current_path.should eq new_content_path
        end
      end

      context "being a guest" do
        it "should show the 404 page" do
          expect do
            visit content_path 'not-there'
          end.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end

  describe "#index" do
    context "when signed in" do
      before { login_as admin }

      it "should show the page" do
        visit contents_path
        current_path.should eq contents_path
      end
    end

    context "when signed out" do
      it "should redirect" do
        visit contents_path
        current_path.should eq new_user_session_path
      end
    end
  end

  describe "#new" do
    context "when signed in" do
      before { login_as admin }

      it "should show the page" do
        visit new_content_path
        current_path.should eq new_content_path
      end

      it "should create a new page" do
        visit new_content_path

        fill_in 'content_key', with: 'foobar'
        fill_in 'content_body', with: 'Bazfuz'

        expect do
          click_button I18n.t 'helpers.submit.create', model: 'Content'
        end.to change(Content, :count).by 1

        page.should have_content 'Content was successfully created.'
        page.should have_content 'Bazfuz'
      end
    end

    context "when signed out" do
      it "should redirect" do
        visit new_content_path
        current_path.should eq new_user_session_path
      end
    end
  end

  describe "#edit" do
    context "when signed in" do
      before { login_as admin }

      it "should show the page" do
        visit edit_content_path content
        current_path.should eq edit_content_path content
      end

      it "should create a new page" do
        visit edit_content_path content

        fill_in 'content_key', with: 'foobar'
        fill_in 'content_body', with: 'Bazfuz'
        click_button I18n.t 'helpers.submit.update', model: 'Content'

        page.should have_content 'Content was successfully updated.'
        page.should have_content 'Bazfuz'
      end
    end

    context "when signed out" do
      it "should redirect" do
        visit edit_content_path content
        current_path.should eq new_user_session_path
      end
    end
  end

  describe "#destroy" do
    context "when signed in" do
      before { login_as admin }

      it "should delete the requested content" do
        content
        visit contents_path
        expect { click_link 'Destroy' }.to change(Content, :count).by(-1)
      end
    end
  end
end
