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
  belongs_to :transaction, :dependent => :destroy
  accepts_nested_attributes_for :transaction

  has_many :library_elements, :dependent => :destroy
  has_many :libraries, through: :library_elements

  belongs_to :seller, class_name: 'User', foreign_key: 'user_id'
  has_many :buyer, through: :transaction, class_name: 'User', foreign_key: 'buyer_id'
  validates_presence_of :user_id

  belongs_to :article_template

  has_many :invoices

  # Misc mixins
  extend Sanitization
   # Article module concerns
  include Categories, Commendation, FeesAndDonations, Images, BuildTransaction, Attributes, Search, Template, State, Scopes

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
        self.images << Image.new(attributes[key]) if attributes[key][:image] != nil
      end
    end
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
        copyimage.is_title = image.is_title
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

  # for featured article
  def profile_name
    if self.seller.type == "PrivateUser"
      self.seller.nickname
    else
      "#{self.seller.nickname}, #{self.seller.city}"
    end
  end


end
