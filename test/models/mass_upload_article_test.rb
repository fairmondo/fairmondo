require 'test_helper'

describe MassUploadArticle do
  subject { MassUploadArticle.new }

  describe 'attributes' do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :mass_upload_id }
    it { subject.must_respond_to :article_id }
    it { subject.must_respond_to :action }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
    it { subject.must_respond_to :row_index }
    it { subject.must_respond_to :validation_errors }
    it { subject.must_respond_to :article_csv }
    it { subject.must_respond_to :process_identifier }
  end
  describe "methods" do
    describe "#done?" do
      it do
        MassUploadArticle.new(:process_identifier => "test").done?.must_equal false
      end
      it do
        MassUploadArticle.new(:process_identifier => "test", :validation_errors => "lala").done?.must_equal true
      end
      it do
        MassUploadArticle.new(:process_identifier => "test", :article => Article.new).done?.must_equal true
      end
    end
  end

end