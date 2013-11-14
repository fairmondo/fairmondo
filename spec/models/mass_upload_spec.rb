require 'spec_helper'

describe MassUpload do
  include CategorySeedData
  include MassUploadCreator

  before :each do
    setup_categories
  end

  describe "methods" do
    let(:legal_entity_user) { FactoryGirl.create :legal_entity, :paypal_data }
    let(:mass_upload) { MassUpload.new }

    describe "#parse_csv_for(user)" do

      context "with valid input file format" do
        let(:correct_mass_upload)   { create_mass_upload('/mass_upload_correct.csv', 'text/csv') }
        let(:correct_attributes) { create_attributes('/mass_upload_correct.csv', 'text/csv') }

        it "should return true" do
          correct_mass_upload.parse_csv_for(legal_entity_user).should be_true
        end
      end

      context "with invalid input file format" do
        let(:incorrect_format_file_mass_upload) do
          create_mass_upload('/mass_upload_wrong_format.html', 'text/html')
        end

        it "should return false" do
          incorrect_format_file_mass_upload.parse_csv_for(legal_entity_user).should be_false
        end

        # it "should add the correct error message" do
        #   incorrect_format_file_mass_upload.errors.full_messages.first.should include(I18n.t('mass_uploads.errors.missing_file'))
        # end
      end

      context "with input file containing a wrong header" do
        let(:incorrect_format_file_mass_upload) { create_mass_upload('/mass_upload_wrong_header.csv', 'text/csv') }
        let(:incorrect_format_file_attributes) { create_attributes('/mass_upload_wrong_header.csv', 'text/csv') }

        it "should return false" do
          incorrect_format_file_mass_upload.parse_csv_for(legal_entity_user).should be_false
        end

        # it "should add the correct error message" do
        #   incorrect_format_file_mass_upload.errors.full_messages.first.should include(I18n.t('mass_uploads.errors.wrong_header'))
        # end
      end

      context "with input file containing a wrong article" do
        let(:incorrect_format_file_mass_upload) { create_mass_upload('/mass_upload_wrong_article.csv', 'text/csv') }
        let(:incorrect_format_file_attributes) { create_attributes('/mass_upload_wrong_article.csv', 'text/csv') }

        it "should return false" do
          incorrect_format_file_mass_upload.parse_csv_for(legal_entity_user).should be_false
        end

        # describe "#save" do
        #   it "should add the correct error message" do
        #     incorrect_format_file_mass_upload.save
        #     incorrect_format_file_mass_upload.errors.full_messages[4].should
        #     include(I18n.t('mass_uploads.errors.wrong_article',
        #       message: I18n.t('mass_uploads.errors.wrong_article_message'),
        #       index: 2))
        #   end
        # end
      end
    end

    describe "#get_csv_encoding" do
      it "should detect a Windows-1252 encoding" do
        pending "Until we find a way to create a file with this encoding"
        mass_upload.send(:get_csv_encoding, 'spec/fixtures/mass_upload_cp1252.csv').should eq 'Windows-1252'
      end

      it "should detect a Mac Roman encoding" do
        mass_upload.send(:get_csv_encoding, 'spec/fixtures/mass_upload_mac.csv').should eq 'MacRoman'
      end

      it "should detect a DOS encoding" do
        # still not sure if this actually works. Does DOS have the euro sign? What about ISO-8859-1?
        pending "Until we find a way to create a file with this encoding"
        mass_upload.send(:get_csv_encoding, 'spec/fixtures/mass_upload_ibm437.csv').should eq 'IBM437'
      end

      it "should detect an ISO-8859-15 encoding" do
        pending "Until we find a way to create a file with this encoding"
        mass_upload.send(:get_csv_encoding, 'spec/fixtures/mass_upload_iso15.csv').should eq 'ISO-8859-15'
      end

      it "should default to a utf-8 encoding" do
        mass_upload.send(:get_csv_encoding, 'spec/fixtures/mass_upload_correct.csv').should eq 'utf-8'
      end
    end
  end
end
