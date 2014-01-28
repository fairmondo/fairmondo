require 'spec_helper'

describe MassUpload do

   describe "methods" do
    #let(:legal_entity_user) { FactoryGirl.create :legal_entity, :paypal_data }
    #let(:db_mass_upload)    { FactoryGirl.create :mass_upload, :user => legal_entity_user }
    #let(:mass_upload)       { MassUpload.new }

    describe "#get_csv_encoding" do
      it "should detect a Windows-1252 encoding" do
        MassUpload::Checks.get_csv_encoding( 'spec/fixtures/mass_upload_cp1252.csv').should eq 'Windows-1252'
      end

      it "should detect a Mac Roman encoding" do
        MassUpload::Checks.get_csv_encoding('spec/fixtures/mass_upload_mac.csv').should eq 'MacRoman'
      end

      it "should detect a DOS encoding" do
        # still not sure if this actually works. Does DOS have the euro sign? What about ISO-8859-1?
        MassUpload::Checks.get_csv_encoding('spec/fixtures/mass_upload_ibm437.csv').should eq 'IBM437'
      end

      it "should detect an ISO-8859-15 encoding" do
        MassUpload::Checks.get_csv_encoding('spec/fixtures/mass_upload_iso15.csv').should eq 'ISO-8859-15'
      end

      it "should default to a utf-8 encoding" do
        MassUpload::Checks.get_csv_encoding( 'spec/fixtures/mass_upload_correct.csv').should eq 'utf-8'
      end

    end

  end
end
