#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class MassUploadTest < ActiveSupport::TestCase
  subject { MassUpload.new }

  describe 'attributes' do
    it { _(subject).must_respond_to :id }
    it { _(subject).must_respond_to :row_count }
    it { _(subject).must_respond_to :failure_reason }
    it { _(subject).must_respond_to :user_id }
    it { _(subject).must_respond_to :created_at }
    it { _(subject).must_respond_to :updated_at }
    it { _(subject).must_respond_to :file_file_name }
    it { _(subject).must_respond_to :file_content_type }
    it { _(subject).must_respond_to :file_file_size }
    it { _(subject).must_respond_to :file_updated_at }
    it { _(subject).must_respond_to :state }
  end

  describe 'methods' do
    # let(:legal_entity_user) { create :legal_entity, :paypal_data }
    # let(:db_mass_upload)    { create :mass_upload, :user => legal_entity_user }
    # let(:mass_upload)       { MassUpload.new }

    describe '#get_csv_encoding' do
      it 'should detect a Windows-1252 encoding' do
        MassUploadConcerns::Checks.get_csv_encoding('test/fixtures/mass_upload_cp1252.csv').must_equal 'Windows-1252'
      end

      it 'should detect a Mac Roman encoding' do
        MassUploadConcerns::Checks.get_csv_encoding('test/fixtures/mass_upload_mac.csv').must_equal 'MacRoman'
      end

      it 'should detect a DOS encoding' do
        # still not sure if this actually works. Does DOS have the euro sign? What about ISO-8859-1?
        MassUploadConcerns::Checks.get_csv_encoding('test/fixtures/mass_upload_ibm437.csv').must_equal 'IBM437'
      end

      it 'should detect an ISO-8859-15 encoding' do
        MassUploadConcerns::Checks.get_csv_encoding('test/fixtures/mass_upload_iso15.csv').must_equal 'ISO-8859-15'
      end

      it 'should default to a utf-8 encoding' do
        MassUploadConcerns::Checks.get_csv_encoding('test/fixtures/mass_upload_correct.csv').must_equal 'utf-8'
      end
    end
  end
end
