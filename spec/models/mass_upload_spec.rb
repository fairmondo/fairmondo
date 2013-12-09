require 'spec_helper'

describe MassUpload do
  include CategorySeedData

  before :each do
    setup_categories
  end

   describe "methods" do
    let(:legal_entity_user) { FactoryGirl.create :legal_entity, :paypal_data }
    let(:mass_upload)   { FactoryGirl.create :mass_upload, :user => legal_entity_user }

    describe "#get_csv_encoding" do
      it "should detect a Windows-1252 encoding" do
        mass_upload.send(:get_csv_encoding, 'spec/fixtures/mass_upload_cp1252.csv').should eq 'Windows-1252'
      end

      it "should detect a Mac Roman encoding" do
        mass_upload.send(:get_csv_encoding, 'spec/fixtures/mass_upload_mac.csv').should eq 'MacRoman'
      end

      it "should detect a DOS encoding" do
        # still not sure if this actually works. Does DOS have the euro sign? What about ISO-8859-1?
        mass_upload.send(:get_csv_encoding, 'spec/fixtures/mass_upload_ibm437.csv').should eq 'IBM437'
      end

      it "should detect an ISO-8859-15 encoding" do
        mass_upload.send(:get_csv_encoding, 'spec/fixtures/mass_upload_iso15.csv').should eq 'ISO-8859-15'
      end

      it "should default to a utf-8 encoding" do
        mass_upload.send(:get_csv_encoding, 'spec/fixtures/mass_upload_correct.csv').should eq 'utf-8'
      end

    end
  end
end
