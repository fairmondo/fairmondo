# Connector model for MassUpload <-> Articles
# with additional action
class MassUploadArticle < ActiveRecord::Base
  belongs_to :article
  belongs_to :mass_upload
end