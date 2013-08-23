require 'spec_helper'

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
      let(:incorrect_format_file_mass_upload) do
        create_mass_upload('/mass_upload_wrong_format.html', 'text/html')
      end
      let(:incorrect_format_file_attributes) { create_attributes('/mass_upload_wrong_format.html', 'text/html') }

      describe "#validate_input(file)" do
        it "should return false" do
          incorrect_format_file_mass_upload.validate_input(incorrect_format_file_attributes).should be_false
        end

        it "should add the correct error message" do
          incorrect_format_file_mass_upload.errors.full_messages.first.should include(I18n.t('mass_upload.errors.missing_file'))
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

          incorrect_format_file_mass_upload.errors.full_messages.first.should include(I18n.t('mass_upload.errors.wrong_header'))
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
            incorrect_format_file_mass_upload.errors.full_messages[4].should
            include(I18n.t('mass_upload.errors.wrong_article',
              message: I18n.t('mass_upload.errors.wrong_article_message'),
              index: 2))
          end
        end
      end
    end
  end
end
