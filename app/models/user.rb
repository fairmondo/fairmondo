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
class User < ActiveRecord::Base

  # Friendly_id for beautiful links
  extend FriendlyId
  friendly_id :nickname, :use => :slugged
  validates_presence_of :slug

  extend Sanitization

  # Include default devise modules. Others available are: :rememberable,
  # :token_authenticatable, :encryptable, :lockable,  and :omniauthable
  devise :database_authenticatable, :registerable, :timeoutable,
         :recoverable, :trackable, :validatable, :confirmable

  after_create :create_default_library

  # Setup accessible (or protected) attributes for your model

  attr_accessible :email, :password, :password_confirmation, :remember_me,
      :nickname, :forename, :surname, :privacy, :legal, :agecheck,
      :invitor_id, :banned, :about_me, :image_attributes, #:trustcommunity,
      :title, :country, :street, :city, :zip, :phone, :mobile, :fax,
      :terms, :cancellation, :about, :bank_code, :paypal_account,
      :bank_account_number, :bank_name, :bank_account_owner, :company_name
  auto_sanitize :nickname, :forename, :surname, :street, :city
  auto_sanitize :about_me, :terms, :cancellation, :about, method: 'tiny_mce'


  # @api public
  def self.attributes_protected_by_default
    ["id"] # default is ["id","type"]
  end


  attr_accessible :type
  attr_protected :admin


  attr_accessor :recaptcha, :bank_account_validation , :paypal_validation


  #Relations
  has_many :articles, :dependent => :destroy
  # has_many :bids, :dependent => :destroy
  # has_many :invitations, :dependent => :destroy

  has_many :article_templates, :dependent => :destroy
  has_many :libraries, :dependent => :destroy

  ##
  has_one :image, as: :imageable, autosave: true
  accepts_nested_attributes_for :image
  ##

  # has_attached_file :image, :styles => { :medium => "520x360>", :thumb => "260x180#" , :mini => "130x90#"},
  #                           :default_url => "missing.png",
  #                           :url => "/system/users/:attachment/:id_partition/:style/:filename",
  #                           :path => "public/system/users/:attachment/:id_partition/:style/:filename"

  #belongs_to :invitor ,:class_name => 'User', :foreign_key => 'invitor_id'


  # validations

  validates_inclusion_of :type, :in => ["PrivateUser", "LegalEntity"]

  validates_presence_of :forename , :on => :update
  validates_presence_of :surname , :on => :update
  validates_presence_of :title , :on => :update
  validates_presence_of :country , :on => :update
  validates_presence_of :street , :on => :update
  validates_presence_of :city , :on => :update

  validates_presence_of :nickname

  validates :zip, :presence => true, :on => :update, :zip => true
  # validates_attachment_content_type :image,:content_type => ['image/jpeg', 'image/png', 'image/gif']
  # validates_attachment_size :image, :in => 0..5.megabytes

  validates :recaptcha, presence: true, acceptance: true, on: :create

  validates :privacy, :acceptance => true, :on => :create
  validates :legal, :acceptance => true, :on => :create
  validates :agecheck, :acceptance => true , :on => :create


  validates :bank_code , :bank_account_number , :bank_name ,:bank_account_owner, :presence => true , :if => :bank_account_validation
  validates :paypal_account , :presence => true , :if => :paypal_validation

  # Return forename plus surname
  # @api public
  # @return [String]
  def fullname
    fullname = "#{self.forename} #{self.surname}"
  end

  # Return user nickname
  # @api public
  # @return [String]
  def name
    name = "#{self.nickname}"
  end

  # Compare IDs of users
  # @api public
  # @param user [User] Usually current_user
  def is? user
    user && self.id == user.id
  end

  # Static method to get admin status even if current_user is nil
  # @api public
  # @param user [User, nil] Usually current_user
  def self.is_admin? user
    user && user.admin?
  end

  # Get generated customer number
  # @api public
  # @return [String] 8-digit number
  def customer_nr
    id.to_s.rjust 8, "0"
  end

  # Get url for user image
  # @api public
  # @param symbol [Symbol] which type
  # @return [String] URL
  def image_url symbol
    (img = image) ? img.image.url(symbol) : "/assets/missing.png"
  end

  private

  # @api private
  def create_default_library
    if self.libraries.empty?
      Library.create(name: I18n.t('library.default'), public: false, user_id: self.id)
    end
  end
end
