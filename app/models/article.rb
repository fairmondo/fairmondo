#
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
class Article < ActiveRecord::Base
  extend Enumerize
  #! attr_accessible

  # Friendly_id for beautiful links
  extend FriendlyId
  friendly_id :title, :use => :slugged
  validates_presence_of :slug unless :template?

  delegate :terms, :cancellation, :about, :country, :ngo, :nickname , :to => :seller, :prefix => true
  delegate :quantity_available, to: :transaction, prefix: true

  delegate :deletable?, :buyer, to: :transaction, prefix: false
  delegate :email, to: :seller, prefix: true
  delegate :nickname, to: :donated_ngo, :prefix => true


  # Relations
  has_one :transaction, conditions: "type != 'PartialFixedPriceTransaction'", dependent: :destroy, inverse_of: :article
  has_many :partial_transactions, class_name: 'PartialFixedPriceTransaction', conditions: "type = 'PartialFixedPriceTransaction'", inverse_of: :article
  accepts_nested_attributes_for :transaction
  # validates_presence_of :transaction

  has_many :library_elements, :dependent => :destroy
  has_many :libraries, through: :library_elements

  has_many :exhibits

  belongs_to :seller, class_name: 'User', foreign_key: 'user_id'
  belongs_to :donated_ngo, class_name: 'User', foreign_key: 'friendly_percent_organisation'

  has_many :mass_upload_articles
  has_many :mass_uploads, through: :mass_upload_articles

  belongs_to :discount

  validates_presence_of :user_id

  belongs_to :article_template

  # Misc mixins
  extend Sanitization
  # Article module concerns
  include Categories, Commendation, DynamicProcessing, Export, FeesAndDonations,
          Images, BuildTransaction, Attributes, Search, Template, State, Scopes,
          Checks, Discountable

  def self.article_attrs with_nested_template = true
    (
      Article.common_attrs + Article.money_attrs + Article.payment_attrs +
      Article.basic_price_attrs + Article.transport_attrs +
      Article.category_attrs + Article.commendation_attrs + Article.search_attrs +
      Article.image_attrs + Article.legal_entity_attrs + Article.fees_and_donation_attrs +
      Article.template_attrs(with_nested_template)
    )
  end

  def images_attributes=(attributes)
    self.images.clear
    attributes.each_key do |key|
      if attributes[key].has_key? :id
        unless attributes[key][:_destroy] == "1"
           image = Image.find(attributes[key][:id])
           image.image = attributes[key][:image] if attributes[key].has_key? :image # updated the image itself
           image.is_title = attributes[key][:is_title]
           self.images << image
        end

      else
        self.images << ArticleImage.new(attributes[key]) if attributes[key][:image] != nil
      end
    end
  end

  def self.edit_as_new article
      new_article = article.amoeba_dup
      if !article.sold?
        #do not remove sold articles, we want to keep them
        #if the old article has errors we still want to remove it from the marketplace
        article.close_without_validation
      end
      new_article.state = "preview"
      new_article
  end

  amoeba do
    enable
    include_field :fair_trust_questionnaire
    include_field :social_producer_questionnaire
    include_field :categories
    nullify :article_template_id
    customize lambda { |original_article, new_article|

      original_article.images.each do |image|
        copyimage = ArticleImage.new
        copyimage.image = image.image
        copyimage.is_title = image.is_title
        copyimage.external_url = image.external_url
        new_article.images << copyimage
        copyimage.save
      end

      if original_article.template? || original_article.save_as_template?
        new_article.slug = nil
      else
        old_slug = original_article.slug
        original_article.slug = old_slug + original_article.id.to_s
        new_article.slug = old_slug
      end

    }
  end

  def should_generate_new_friendly_id?
    super && slug == nil
  end



end
