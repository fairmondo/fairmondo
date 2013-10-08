require 'spec_helper'

describe MassUpload do
  include CategorySeedData
  include MassUploadCreator

  before :each do
    setup_categories
  end

  describe "methods" do
    let(:legal_entity_user) { FactoryGirl.create :legal_entity, :paypal_data }

    describe "with valid input file format" do
      let(:correct_mass_upload)   { create_mass_upload('/mass_upload_correct.csv', 'text/csv') }
      let(:correct_attributes) { create_attributes('/mass_upload_correct.csv', 'text/csv') }

      describe "#parse_csv_for(user)" do
        it "should return true" do
          correct_mass_upload.parse_csv_for(legal_entity_user).should be_true
        end
      end
    end

    describe "with invalid input file format" do
      let(:incorrect_format_file_mass_upload) do
        create_mass_upload('/mass_upload_wrong_format.html', 'text/html')
      end

      describe "#parse_csv_for(user)" do
        it "should return false" do
          incorrect_format_file_mass_upload.parse_csv_for(legal_entity_user).should be_false
        end

        # it "should add the correct error message" do
        #   incorrect_format_file_mass_upload.errors.full_messages.first.should include(I18n.t('mass_upload.errors.missing_file'))
        # end
      end
    end

    describe "with input file containing a wrong header" do
      let(:incorrect_format_file_mass_upload) { create_mass_upload('/mass_upload_wrong_header.csv', 'text/csv') }
      let(:incorrect_format_file_attributes) { create_attributes('/mass_upload_wrong_header.csv', 'text/csv') }

      describe "#parse_csv_for(user)" do
        it "should return false" do
          incorrect_format_file_mass_upload.parse_csv_for(legal_entity_user).should be_false
        end

        # it "should add the correct error message" do
        #   incorrect_format_file_mass_upload.errors.full_messages.first.should include(I18n.t('mass_upload.errors.wrong_header'))
        # end
      end
    end

    describe "with input file containing a wrong header" do
      let(:incorrect_format_file_mass_upload) { create_mass_upload('/mass_upload_wrong_article.csv', 'text/csv') }
      let(:incorrect_format_file_attributes) { create_attributes('/mass_upload_wrong_article.csv', 'text/csv') }

      describe "#parse_csv_for(user)" do
        it "should return true" do
          incorrect_format_file_mass_upload.parse_csv_for(legal_entity_user).should be_true
        end

        # describe "#save" do
        #   it "should add the correct error message" do
        #     incorrect_format_file_mass_upload.save
        #     incorrect_format_file_mass_upload.errors.full_messages[4].should
        #     include(I18n.t('mass_upload.errors.wrong_article',
        #       message: I18n.t('mass_upload.errors.wrong_article_message'),
        #       index: 2))
        #   end
        # end
      end
    end
  end
end
