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

  # Action attribute: c/create/u/update/d/delete - for export and csv upload
  # keep_images attribute: see edit_as_new
  attr_accessor :action, :keep_images

  validates_presence_of :slug unless :template?

  delegate :terms, :cancellation, :about, :country, :ngo, :nickname , :to => :seller, :prefix => true
  delegate :quantity_available, to: :transaction, prefix: true

  delegate :deletable?, :buyer, to: :transaction, prefix: false
  delegate :email, :vacationing?, to: :seller, prefix: true
  delegate :nickname, to: :friendly_percent_organisation, :prefix => true


  # Relations
  has_one :transaction, -> { where("type != 'PartialFixedPriceTransaction'") }, dependent: :destroy, inverse_of: :article
  has_many :partial_transactions, -> { where(type: 'PartialFixedPriceTransaction') }, class_name: 'PartialFixedPriceTransaction' , inverse_of: :article
  accepts_nested_attributes_for :transaction
  # validates_presence_of :transaction

  has_many :library_elements, :dependent => :destroy
  has_many :libraries, through: :library_elements

  has_many :exhibits

  belongs_to :seller, class_name: 'User', foreign_key: 'user_id'
  belongs_to :friendly_percent_organisation, class_name: 'User', foreign_key: 'friendly_percent_organisation_id'

  has_many :mass_upload_articles
  has_many :mass_uploads, through: :mass_upload_articles

  belongs_to :discount

  validates_presence_of :user_id

  belongs_to :article_template

  # Misc mixins
  extend Sanitization
  # Article module concerns
  include Categories, Commendation, FeesAndDonations,
          Images, BuildTransaction, Attributes, Template, State, Scopes,
          Checks, Discountable

  # Elastic

  include Tire::Model::Search

  settings Indexer.settings do
    mapping do
      indexes :id,           :index => :not_analyzed
      indexes :title,  type: 'multi_field'  , :fields => {
         :search => { type: 'string', analyzer: "decomp_stem_analyzer"},
         :decomp => { type: 'string', analyzer: "decomp_analyzer"},
      }
      indexes :content,      analyzer: "decomp_stem_analyzer"
      indexes :gtin,         :index    => :not_analyzed

      # filters

      indexes :fair, :type => 'boolean'
      indexes :ecologic, :type => 'boolean'
      indexes :small_and_precious, :type => 'boolean'
      indexes :condition
      indexes :categories, :as => Proc.new { self.categories.map{|c| c.self_and_ancestors.map(&:id) }.flatten  }


      # sorting
      indexes :created_at, :type => 'date'

      # stored attributes

      indexes :slug
      indexes :title_image_url_thumb, :as => 'title_image_url_thumb'
      indexes :price, :as => 'price_cents', :type => 'long'
      indexes :basic_price, :as => 'basic_price_cents', :type => 'long'
      indexes :basic_price_amount
      indexes :vat, :type => 'long'

      indexes :friendly_percent, :type => 'long'
      indexes :friendly_percent_organisation , :as => 'friendly_percent_organisation_id'
      indexes :friendly_percent_organisation_nickname, :as => Proc.new { friendly_percent_organisation ? self.friendly_percent_organisation_nickname : nil }

      indexes :transport_pickup
      indexes :zip, :as => Proc.new {self.transport_pickup ? self.seller.zip : nil}

      # seller attributes
      indexes :belongs_to_legal_entity? , :as => 'belongs_to_legal_entity?'
      indexes :seller_ngo, :as => 'seller_ngo'
      indexes :seller_nickname, :as => 'seller_nickname'
      indexes :seller, :as => 'seller.id'


    end
  end

  def self.article_attrs with_nested_template = true
    (
      Article.common_attrs + Article.money_attrs + Article.payment_attrs +
      Article.basic_price_attrs + Article.transport_attrs +
      Article.category_attrs + Article.commendation_attrs  +
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

      article.keep_images = true unless article.sold?

      new_article = article.amoeba_dup

      #do not remove sold articles, we want to keep them
      #if the old article has errors we still want to remove it from the marketplace
      article.close_without_validation unless article.sold?

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
        if original_article.keep_images
          image.imageable_id = nil
          new_article.images << image
          image.save
        else
          begin
            copyimage = ArticleImage.new
            copyimage.image = image.image
            copyimage.is_title = image.is_title
            copyimage.external_url = image.external_url
            new_article.images << copyimage
            copyimage.save
          rescue
          end
        end
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
