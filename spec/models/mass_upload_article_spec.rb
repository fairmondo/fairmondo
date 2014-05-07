require 'spec_helper'

describe MassUploadArticle do
  describe 'attributes' do
    it { should respond_to :id }
    it { should respond_to :mass_upload_id }
    it { should respond_to :article_id }
    it { should respond_to :action }
    it { should respond_to :created_at }
    it { should respond_to :updated_at }
    it { should respond_to :row_index }
    it { should respond_to :validation_errors }
    it { should respond_to :article_csv }
    it { should respond_to :process_identifier }
  end
  describe "methods" do
    describe "#done?" do
      it do
        MassUploadArticle.new(:process_identifier => "test").done?.should be_false
      end
      it do
        MassUploadArticle.new(:process_identifier => "test", :validation_errors => "lala").done?.should be_true
      end
      it do
        MassUploadArticle.new(:process_identifier => "test", :article => Article.new).done?.should be_true
      end
    end
  end

end