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
    describe "#still_working_or_done?" do
      it do
        Sidekiq::Status.stub(:status).and_return(:working)
        MassUploadArticle.new(:process_identifier => "test").still_working_or_done?.should be_true
      end
    end
  end

end