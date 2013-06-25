# encoding: utf-8
# bugbug

require 'spec_helper'
require 'ruby-debug'

describe MassUpload do
  include CategorySeedData
  include MassUploadCreator

  before :each do
    setup_categories
  end

  # bugbug Macht das Sinn? Teilweise benutzen wir doch auch inkorrekte...
  subject { correct_mass_upload }


  describe "methods" do

    describe "with valid input file format" do
      let(:correct_mass_upload)   { create_mass_upload('/mass_upload_correct.csv', 'text/csv') }
      let(:correct_attributes) { create_attributes('/mass_upload_correct.csv', 'text/csv') }

      describe "#validate_input(file)" do
        it "should return true" do
          correct_mass_upload.validate_input(correct_attributes).should be_true
        end
      end
    end

    describe "with invalid input file format" do
      # before { @incorrect_format_file_mass_upload = create_mass_upload('/mass_upload_wrong_format.html', 'text/html') }
      let(:incorrect_format_file_mass_upload) do
        create_mass_upload('/mass_upload_wrong_format.html', 'text/html')
      end
      let(:incorrect_format_file_attributes) { create_attributes('/mass_upload_wrong_format.html', 'text/html') }

      describe "#validate_input(file)" do
        it "should return false" do
          incorrect_format_file_mass_upload.validate_input(incorrect_format_file_attributes).should be_false
        end

        it "should add the correct error message" do
          # The "file" at the beginning of the string seems necessary but is
          # confusing. Should be checked when starting to use
          # internationalization
          incorrect_format_file_mass_upload.errors.full_messages.should include("file Bitte wähle eine CSV-Datei aus")
        end
      end
    end

    describe "with input file containing a wrong header" do
      let(:incorrect_format_file_mass_upload) { create_mass_upload('/mass_upload_wrong_header.csv', 'text/csv') }
      let(:incorrect_format_file_attributes) { create_attributes('/mass_upload_wrong_header.csv', 'text/csv') }

      describe "#validate_input(file)" do
        it "should return false" do
          incorrect_format_file_mass_upload.validate_input(incorrect_format_file_attributes).should be_false
        end

        it "should add the correct error message" do
          # The "file" at the beginning of the string seems necessary but is
          # confusing. Should be checked when starting to use
          # internationalization
          incorrect_format_file_mass_upload.errors.full_messages.should include("file Bei der ersten Zeile muss es sich um einen korrekten Header handeln")
        end
      end
    end

    describe "with input file containing a wrong header" do
      let(:incorrect_format_file_mass_upload) { create_mass_upload('/mass_upload_wrong_article.csv', 'text/csv') }
      let(:incorrect_format_file_attributes) { create_attributes('/mass_upload_wrong_article.csv', 'text/csv') }

      describe "#validate_input(file)" do
        it "should return true" do
          incorrect_format_file_mass_upload.validate_input(incorrect_format_file_attributes).should be_true
        end

        describe "#save" do
          it "should add the correct error message" do
            incorrect_format_file_mass_upload.save
            # The "file" at the beginning of the string seems necessary but is
            # confusing. Should be checked when starting to use
            # internationalization
            incorrect_format_file_mass_upload.errors.full_messages.should include("file Content muss ausgefüllt werden (Artikelzeile 2)")
          end
        end
      end
    end
  end
end
