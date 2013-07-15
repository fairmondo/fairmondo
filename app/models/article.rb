#
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
class Article < ActiveRecord::Base
  extend Enumerize

  attr_accessible
  extend AccessibleForAdmins

  # Friendly_id for beautiful links
  extend FriendlyId
  friendly_id :title, :use => :slugged
  validates_presence_of :slug unless :template?

  #only generate friendly slug if we dont have a template
  def should_generate_new_friendly_id?
    !template?
  end

  delegate :terms, :cancellation, :about, :country , :to => :seller, :prefix => true

  # Relations
  validates_presence_of :transaction , :unless => :template?
  belongs_to :transaction, :dependent => :destroy
  accepts_nested_attributes_for :transaction

  has_many :library_elements, :dependent => :destroy
  has_many :libraries, through: :library_elements

  belongs_to :seller, :class_name => 'User', :foreign_key => 'user_id'
  validates_presence_of :user_id, :unless => :template?

  belongs_to :article_template

  # Misc mixins
  extend Sanitization
   # Article module concerns
  include Categories, Commendation, FeesAndDonations, Images, Initial, Attributes, Search, Template, State, Scopes

  def images_attributes=(attributes)
    self.images.clear
    attributes.each_key do |key|
      if attributes[key].has_key? :id
        self.images << Image.find(attributes[key][:id]) unless attributes[key][:_destroy] == "1"
      else
        self.images << Image.new(attributes[key])
      end
    end
  end


  # We have to do this in the article class because we want to
  # override the dynamic Rails method to get rid of the RecordNotFound
  # http://stackoverflow.com/questions/9864501/recordnotfound-with-accepts-nested-attributes-for-and-belongs-to
  def seller_attributes=(seller_attrs)
    if seller_attrs.has_key?(:id)
      self.seller = User.find(seller_attrs.delete(:id))
      rejected = seller_attrs.reject { |k,v| valid_seller_attributes.include?(k) }
      if rejected != nil && !rejected.empty? # Docs say reject! will return nil for no change but returns empty array
        raise SecurityError
      end
      self.seller.attributes = seller_attrs
    end
  end

   # The allowed attributes for updating user/seller in article form
  def valid_seller_attributes
    ["bank_code", "bank_account_number", "bank_account_owner" ,"paypal_account", "bank_name" ]
  end

  amoeba do
    enable
    include_field :fair_trust_questionnaire
    include_field :social_producer_questionnaire
    include_field :categories
    nullify :slug
    nullify :transaction_id
    nullify :article_template_id
    customize lambda { |original_article, new_article|
      original_article.images.each do |image|
        copyimage = Image.new
        copyimage.image = image.image
        new_article.images << copyimage
        copyimage.save
      end
    }
  end

  # Does this article belong to user X?
  # @api public
  # param user [User] usually current_user
  def owned_by? user
    user && self.seller.id == user.id
  end

end
