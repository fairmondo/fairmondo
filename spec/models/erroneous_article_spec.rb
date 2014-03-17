require 'spec_helper'

describe ErroneousArticle do
  describe 'attributes' do
    it { should respond_to :id }
    it { should respond_to :mass_upload_id }
    it { should respond_to :row_index }
    it { should respond_to :validation_errors }
    it { should respond_to :article_csv }
    it { should respond_to :created_at }
    it { should respond_to :updated_at }

  end

  pending "add some examples to (or delete) #{__FILE__}"
end
