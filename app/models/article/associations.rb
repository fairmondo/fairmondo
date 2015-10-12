#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module Article::Associations
  extend ActiveSupport::Concern

  included do
    has_and_belongs_to_many :categories

    has_many :business_transactions, inverse_of: :article
    has_many :line_items, inverse_of: :article

    has_many :library_elements, dependent: :destroy
    has_many :libraries, through: :library_elements

    belongs_to :seller, class_name: 'User', foreign_key: 'user_id'
    alias_method :user, :seller
    alias_method :user=, :seller=

    belongs_to :original, class_name: 'Article', foreign_key: 'original_id'
    # the article that this article is a copy of, if applicable

    has_many :mass_upload_articles
    has_many :mass_uploads, through: :mass_upload_articles

    belongs_to :friendly_percent_organisation,
               class_name: 'User', foreign_key: 'friendly_percent_organisation_id'
    belongs_to :discount

    # images

    has_many :images, class_name: 'ArticleImage', foreign_key: 'imageable_id', autosave: true
    has_many :thumbnails, -> { reorder('is_title DESC, id ASC').offset(1) },
             class_name: 'ArticleImage', foreign_key: 'imageable_id'
    has_one :title_image, -> { reorder('is_title DESC, id ASC') },
            class_name: 'ArticleImage', foreign_key: 'imageable_id'

    accepts_nested_attributes_for :images, allow_destroy: true
  end
end
