class ErroneousArticle < ActiveRecord::Base
  attr_accessible :article_csv, :mass_upload_id, :validation_errors

  belongs_to :mass_upload
end
