# encoding: utf-8
# bugbug

require 'spec_helper'

include Warden::Test::Helpers
include CategorySeedData

describe "mass-upload" do

  let (:user) { FactoryGirl.create :user }

  subject { page }

  context "for non signed-in users" do
    it "should rediret to login page" do
      visit new_mass_upload_path
      current_path.should eq new_user_session_path
      should have_selector('h1', text: 'Login')
    end
  end

  context "for signed-in users" do

    before do
      login_as user
      visit new_mass_upload_path
    end

    it "should have the correct title" do
      should have_selector('h2', text: 'Artikel importieren')
    end

    describe "correct error message" do

      it "should be shown when not selecting a file" do
        click_button "Artikel hochladen"
        should have_selector('p.inline-errors', text: 'Bitte wähle eine CSV-Datei aus')
      end

      it "should be shown when trying to upload a html file" do
        attach_file('mass_upload_file', 'spec/fixtures/mass_upload_wrong_format.html')
        click_button "Artikel hochladen"
        should have_selector('p.inline-errors', text: 'Bitte wähle eine CSV-Datei aus')
      end

      it "should be shown when trying to upload a csv file with a wrong header" do
        attach_file('mass_upload_file', 'spec/fixtures/mass_upload_wrong_header.csv')
        click_button "Artikel hochladen"
        should have_selector('p.inline-errors', text: 'Bei der ersten Zeile muss es sich um einen korrekten Header handeln')
      end

      # bugbug Der zweite it block gehört hier nicht rein. Besser not dry als schlecht zugeordnet?
      describe "when uploading a csv file with a wrong article" do
        before do
          setup_categories
          attach_file('mass_upload_file', 'spec/fixtures/mass_upload_wrong_article.csv')
        end

        it "should be shown" do
          click_button "Artikel hochladen"
          should have_selector('p.inline-errors', text: 'Content muss ausgefüllt werden (Artikelzeile 2)')
        end

        it "should also not create new articles" do
          expect { click_button "Artikel hochladen" }.not_to change(Article, :count)
        end
      end
    end


    describe "when uploading a correct csv file" do
      before do
        setup_categories
        attach_file('mass_upload_file', 'spec/fixtures/mass_upload_correct.csv')
      end

      describe "it should redirect to the mass_uploads#show" do
        before { click_button "Artikel hochladen" }
        it { should have_content('dummytitle3') }
      end

      it "should create new articles" do
        expect { click_button "Artikel hochladen" }.to change(Article, :count).by(2)
      end
    end
  end
end
