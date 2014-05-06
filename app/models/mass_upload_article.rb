# Connector model for MassUpload <-> Articles
# with additional action
class MassUploadArticle < ActiveRecord::Base
  belongs_to :article
  belongs_to :mass_upload
  default_scope order('row_index ASC')

  def done?
    self.article.present? || self.validation_errors.present?
  end

end