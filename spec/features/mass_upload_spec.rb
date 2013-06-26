# encoding: utf-8
# bugbug

require 'spec_helper'

# bugbug What exactly is this Warden thing anyway???
include Warden::Test::Helpers
include CategorySeedData

describe "mass-upload" do

  let (:user) { FactoryGirl.create :user }

  subject { page }

  describe "for signed-out users" do
    # bugbugb Why is the before necessary? I don't like it, I don't want it!
    before { visit new_mass_upload_path }
    it { should have_selector('h1', text: 'Login') }
  end

  describe "for signed-in users" do

    before do
      login_as user
      visit new_mass_upload_path
    end

    describe "it should render the correct page" do
      it { should have_selector('h2', text: 'Artikel importieren') }
    end

    describe "it should show the correct error message when trying to upload without selecting a file" do
      before { click_button "Artikel hochladen" }
      # bugbugb Is there a better way to check for errors?
      it { should have_selector('p.inline-errors', text: 'Bitte wähle eine CSV-Datei aus')}
    end

    describe "it should show the correct error message when trying to upload a html file" do
      before do
        attach_file('mass_upload_file', 'spec/fixtures/mass_upload_wrong_format.html')
        click_button "Artikel hochladen"
      end
      # bugbugb Is there a better way to check for errors?
      it { should have_selector('p.inline-errors', text: 'Bitte wähle eine CSV-Datei aus')}
    end

    describe "it should show the correct error message when trying to upload a csv file with a wrong header" do
      before do
        attach_file('mass_upload_file', 'spec/fixtures/mass_upload_wrong_header.csv')
        click_button "Artikel hochladen"
      end
      # bugbugb Is there a better way to check for errors?
      it { should have_selector('p.inline-errors', text: 'Bei der ersten Zeile muss es sich um einen korrekten Header handeln') }
    end

    describe "when uploading a csv file with a wrong article" do
      before do
        # bugbug Since I use this twice, how to dry it up?
        setup_categories
        attach_file('mass_upload_file', 'spec/fixtures/mass_upload_wrong_article.csv')
      end

      describe "it should show the correct error messages" do
        # bugbug Not dry but what to to whe I need to use expect below?
        before { click_button "Artikel hochladen" }
        # bugbugb Is there a better way to check for errors?
        it { should have_selector('p.inline-errors', text: 'Content muss ausgefüllt werden (Artikelzeile 2)') }
      end

      # Why do I need a 'it' block outside in order to make expect work?
      it "should not create new articles" do
        expect { click_button "Artikel hochladen" }.not_to change(Article, :count)
      end
    end

    describe "when uploading a correct csv file" do
      before do
        setup_categories
        attach_file('mass_upload_file', 'spec/fixtures/mass_upload_correct.csv')
      end

      describe "it should redirect to the mass_uploads#show" do
        # bugbug Not dry but what to to whe I need to use expect below?
        before { click_button "Artikel hochladen" }
        # bugbugb Is there a better way to check for errors?
        it { should have_content('dummytitle3') }
        # Anyway to check if I'm on the right path? The following doesn't work:
        # it { current_path.should eq "mass_upload_path" }
        # probably because of the secret_number + I can't access the session
      end

      # Why do I need a 'it' block outside in order to make expect work?
      it "should create new articles" do
        expect { click_button "Artikel hochladen" }.to change(Article, :count).by(2)
      end
    end
  end
end
