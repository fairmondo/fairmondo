#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module MassUpload::Associations
  extend ActiveSupport::Concern

  included do
    has_many :mass_upload_articles
    has_many :articles, through: :mass_upload_articles

    has_many :created_articles, -> { where('mass_upload_articles.action' => 'create') }, through: :mass_upload_articles, source: :article
    has_many :updated_articles, -> { where('mass_upload_articles.action' => 'update') }, through: :mass_upload_articles, source: :article
    has_many :deleted_articles, -> { where('mass_upload_articles.action' => 'delete') }, through: :mass_upload_articles, source: :article
    has_many :deactivated_articles, -> { where('mass_upload_articles.action' => 'deactivate') }, through: :mass_upload_articles, source: :article
    has_many :activated_articles, -> { where('mass_upload_articles.action' => 'activate') }, through: :mass_upload_articles, source: :article
    has_many :articles_for_mass_activation, -> { where("mass_upload_articles.action IN ('create', 'update', 'activate')") }, through: :mass_upload_articles, source: :article
    has_many :skipped_articles, -> { where('mass_upload_articles.action' => 'nothing') }, through: :mass_upload_articles, source: :article

    has_many :valid_mass_upload_articles, -> { where(validation_errors: nil).where.not(article_id: nil) }, class_name: 'MassUploadArticle'
    has_many :erroneous_articles, -> { where.not(validation_errors: nil) }, class_name: 'MassUploadArticle'

    has_attached_file :file
    belongs_to :user

    delegate :nickname, to: :user, prefix: true

    validates_attachment :file, presence: true,
                                size: { in: 0..100.megabytes },
                                content_type: {
                                  content_type: %w(
                                    text/csv application/excel text/anytext
                                    application/vnd.msexcel
                                    application/vnd.ms-excel
                                    application/octet-stream
                                    application/force-download
                                    text/comma-separated-values
                                  )
                                }
  end
end
