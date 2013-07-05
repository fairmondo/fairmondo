# encoding: utf-8
# bugbug Because of hard coded error message for signed-in users with wrong
# wrong articles should show correct error message

require 'spec_helper'

include Warden::Test::Helpers
include CategorySeedData

describe "mass-upload" do

  let (:private_user) { FactoryGirl.create :user }
  let (:legal_entity_user) { FactoryGirl.create :legal_entity }

  subject { page }

  context "for non signed-in users" do
    it "should rediret to login page" do
      visit new_mass_upload_path
      current_path.should eq new_user_session_path
      should have_selector(:link_or_button, text: 'Login')
    end
  end

  context "for signed-in private users" do

    before do
      login_as private_user
      visit new_article_path
    end

    it "should not have a csv upload link" do
      # bugbug should this be put into an internationalization file?
      should_not have_link('Artikel per CSV importieren', href: new_mass_upload_path)
    end

  end

  context "for signed-in legal entity users" do

    before do
      login_as legal_entity_user
      visit new_article_path
    end

    it "should have a csv upload link" do
      # bugbug should this be put into an internationalization file?
      should have_link('Artikel per CSV importieren', href: new_mass_upload_path)
    end

    context "after visiting the new_mass_upload_path" do

      before do
        click_link 'Artikel per CSV importieren'
      end

      it "should have the correct title" do
        should have_selector('h2', text: 'Artikel importieren')
      end

      context "uploading" do

        it "should show correct error messages when not selecting a file" do
          click_button I18n.t('mass_upload.labels.upload_article')
          should have_selector('p.inline-errors', text: I18n.t('mass_upload.errors.missing_file'))
        end

        it "should show correct error messages when selecting a html file" do
          attach_file('mass_upload_file', 'spec/fixtures/mass_upload_wrong_format.html')
          click_button I18n.t('mass_upload.labels.upload_article')
          should have_selector('p.inline-errors', text: I18n.t('mass_upload.errors.missing_file'))
        end

        context "when selecting a csv file" do

          before { setup_categories }

          context "with a wrong header" do

            before do
              attach_file('mass_upload_file', 'spec/fixtures/mass_upload_wrong_header.csv')
            end

            it "should show correct error messages" do
              click_button I18n.t('mass_upload.labels.upload_article')
              should have_selector('p.inline-errors', text: I18n.t('mass_upload.errors.wrong_header'))
            end

            it "should not create new articles" do
              expect { click_button "Artikel hochladen" }.not_to change(Article, :count)
            end
          end

          context "with wrong articles" do

            before do
              attach_file('mass_upload_file', 'spec/fixtures/mass_upload_wrong_article.csv')
            end

            it "should show correct error messages" do
              click_button I18n.t('mass_upload.labels.upload_article')
              should have_selector('p.inline-errors', text: 'Content muss ausgefüllt werden (Artikelzeile 2)')
            end

            it "should not create new articles" do
              expect { click_button I18n.t('mass_upload.labels.upload_article') }.not_to change(Article, :count)
            end
          end

          context "with only valid articles" do

            before do
              attach_file('mass_upload_file', 'spec/fixtures/mass_upload_correct.csv')
            end

            it "should redirect to the mass_uploads#show" do
              click_button I18n.t('mass_upload.labels.upload_article')
              should have_content('dummytitle3')
            end

            it "should create new articles" do
              expect { click_button I18n.t('mass_upload.labels.upload_article') }.to change(Article, :count).by(2)
            end
          end
        end
      end
    end
  end
end
