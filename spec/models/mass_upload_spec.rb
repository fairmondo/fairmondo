require 'spec_helper'

describe MassUpload do
  include CategorySeedData

  before :each do
    setup_categories
  end

   describe "methods" do
    let(:legal_entity_user) { FactoryGirl.create :legal_entity, :paypal_data }
    let(:db_mass_upload)    { FactoryGirl.create :mass_upload, :user => legal_entity_user }
    let(:mass_upload)       { MassUpload.new }

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
    describe "#process_without_delay" do
      it "should output the backtrace on unknown errors" do
        db_mass_upload.stub(:get_csv_encoding)
        CSV.stub(:foreach).and_raise(NoMethodError)
        db_mass_upload.process_without_delay
        db_mass_upload.failed?.should be_true
      end
    end
    describe "#process_row" do
      it "should output the backtrace on unknown errors" do
        Category.stub(:find_imported_categories).and_raise(NoMethodError)
        db_mass_upload.start
        db_mass_upload.process_row Hash.new, 1
        db_mass_upload.failed?.should be_true
      end
    end
  end
end
