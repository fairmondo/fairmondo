# Connector model for MassUpload <-> Articles
# with additional action
class MassUploadArticle < ActiveRecord::Base
  belongs_to :article
  belongs_to :mass_upload
  default_scope order('row_index ASC')

  def still_working_or_done?
    status = Sidekiq::Status::status(self.process_identifier)
    return false unless status
    still_working = [:queued,:working, :failed].include? status
    done = (status == :complete and self.article.present?)
    still_working || done
  end

end