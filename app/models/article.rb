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
  extend FriendlyId
  include Commentable

  # Friendly_id for beautiful links
  def slug_candidates
    [
      :title,
      [:title, :seller_nickname],
      [:title, :seller_nickname, :created_at ]
    ]
  end

  friendly_id :slug_candidates, :use => [:slugged, :finders]

  # Action attribute: c/create/u/update/d/delete - for export and csv upload
  # keep_images attribute: see edit_as_new
  attr_accessor :action, :keep_images, :save_as_template
  attr_writer :article_search_form #find a way to remove this! arcane won't like it

  validates_presence_of :slug unless :template?

  delegate :terms, :cancellation, :about, :country, :ngo, :nickname , :to => :seller, :prefix => true
  delegate :quantity_available, to: :business_transaction, prefix: true

  delegate :deletable?, :buyer, to: :business_transaction, prefix: false
  delegate :email, :vacationing?, to: :seller, prefix: true
  delegate :nickname, to: :friendly_percent_organisation, :prefix => true


  # Relations
  has_one :business_transaction, -> { where("type != 'PartialFixedPriceTransaction'") }, dependent: :destroy, inverse_of: :article
  has_many :partial_business_transactions, -> { where(type: 'PartialFixedPriceTransaction') }, class_name: 'PartialFixedPriceTransaction', inverse_of: :article
  accepts_nested_attributes_for :business_transaction
  # validates_presence_of :business_transaction

  has_many :library_elements, :dependent => :destroy
  has_many :libraries, through: :library_elements

  belongs_to :seller, class_name: 'User', foreign_key: 'user_id'
  alias_method :user, :seller
  alias_method :user=, :seller=

  belongs_to :friendly_percent_organisation, class_name: 'User', foreign_key: 'friendly_percent_organisation_id'

  has_many :mass_upload_articles
  has_many :mass_uploads, through: :mass_upload_articles

  belongs_to :discount

  validates_presence_of :user_id


  # Misc mixins
  extend Sanitization
  # Article module concerns
  include Categories, Commendation, FeesAndDonations,
          Images, BuildBusinessTransaction, Attributes, State, Scopes,
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
      indexes :swappable, :type => 'boolean'
      indexes :borrowable, :type => 'boolean'
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
      indexes :zip, :as => Proc.new { self.seller.zip if self.transport_pickup || self.seller.is_a?(LegalEntity) }

      # seller attributes
      indexes :belongs_to_legal_entity? , :as => 'belongs_to_legal_entity?'
      indexes :seller_ngo, :as => 'seller_ngo'
      indexes :seller_nickname, :as => 'seller_nickname'
      indexes :seller, :as => 'seller.id'


    end
  end

  def save_as_template?
    self.save_as_template == "1"
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
    customize lambda { |original_article, new_article|
      new_article.categories = original_article.categories

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

      if original_article.is_template? || original_article.save_as_template?
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


  def is_template?
    self.state.to_sym == :template
  end

  # overwrite has_many(:comments) getter to only return publishable comments for LegalEntities
  def comments_with_publishable_mod
    if seller.is_a? LegalEntity
      comments_without_publishable_mod.legal_entity_publishable
    else
      comments_without_publishable_mod
    end
  end
  alias :comments_without_publishable_mod :comments
  alias :comments :comments_with_publishable_mod

end
