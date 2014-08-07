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
class User < ActiveRecord::Base
  extend Memoist
  extend Tokenize

  # Friendly_id for beautiful links
  extend FriendlyId

  friendly_id :nickname, use: [:slugged, :finders]

  validates_presence_of :slug

  extend Sanitization

  # Include default devise modules. Others available are: :rememberable,
  # :token_authenticatable, :encryptable, :lockable,  and :omniauthable
  devise :database_authenticatable, :registerable, :timeoutable,
         :recoverable, :trackable, :validatable, :confirmable

  after_create :create_default_library

  auto_sanitize :nickname, :bank_name
  auto_sanitize :iban, :bic, remove_all_spaces: true
  auto_sanitize :about_me, :terms, :cancellation, :about, method: 'tiny_mce'


  attr_accessor :wants_to_sell
  attr_accessor :bank_account_validation , :paypal_validation
  attr_accessor :fastbill_profile_update


  ####################################################
  # Relations
  #
  ####################################################

    # Addresses
  has_many :addresses, dependent: :destroy, inverse_of: :user
  belongs_to :standard_address, class_name: 'Address', foreign_key: :standard_address_id
  delegate :title, :first_name, :last_name, :company_name, :address_line_1, :address_line_2, :zip, :city, :country, to: :standard_address, prefix: true

    # Profile image
  has_one :image, class_name: "UserImage", foreign_key: "imageable_id"
  accepts_nested_attributes_for :image

    # Articles and Mass uploads
  has_many :articles, dependent: :destroy # As seller
  #has_many :bought_business_transactions, through: :buyer_line_item_groups#, source: :line_item_groups
  #has_many :bought_articles, through: :bought_business_transactions, source: :article
  has_many :mass_uploads

    # Cart related Models
  has_many :carts # as buyer
  #has_many :line_item_groups, foreign_key: 'seller_id', inverse_of: :seller # as seller
  #has_many :line_item_groups, foreign_key: 'buyer_id', inverse_of: :buyer  # as buyer
  has_many :seller_line_item_groups, class_name: 'LineItemGroup', foreign_key: 'seller_id', inverse_of: :seller
  has_many :buyer_line_item_groups, class_name: 'LineItemGroup', foreign_key: 'buyer_id', inverse_of: :buyer

    # Libraries and Library Elements
  has_many :libraries, dependent: :destroy
  has_many :library_elements, through: :libraries

    # Ratings
  has_many :ratings, foreign_key: 'rated_user_id', dependent: :destroy, inverse_of: :rated_user
  has_many :given_ratings, through: :buyer_line_item_groups, source: :rating, inverse_of: :rating_user

    # Notices
  has_many :notices

  has_many :library_elements, through: :libraries

  has_many :hearts
  has_many :comments, dependent: :destroy

  has_attached_file :cancellation_form


  ####################################################
  # Scopes
  #
  ####################################################
  scope :sorted_ngo, -> { order(:nickname).where(ngo: true) }
  scope :ngo_with_profile_image, -> { where(ngo: true ).joins(:image).limit(6) }


  ####################################################
  # validations
  #
  ####################################################

  # Registration validations

  validates_inclusion_of :type, in: ["PrivateUser", "LegalEntity"]
  validates :nickname , presence: true, uniqueness: true
  validates :legal, acceptance: true, on: :create
  validates :agecheck, acceptance: true , on: :create
  validates_associated :standard_address

  with_options if: :wants_to_sell? do |seller|
    seller.validates :direct_debit, acceptance: {accept: true}, on: :update
    seller.validates :bank_code, :bank_account_number,:bank_name ,:bank_account_owner, :iban,:bic,  presence: true
    seller.validates :standard_address, presence: true
  end

  # TODO: Language specific validators
  # german validator for iban
  validates :iban, format: {with: /\A[A-Za-z]{2}[0-9]{2}[A-Za-z0-9]{18}\z/ }, unless: Proc.new {|c| c.iban.blank?}, if: :is_german?
  validates :bic, format: {with: /\A[A-Za-z]{4}[A-Za-z]{2}[A-Za-z0-9]{2}[A-Za-z0-9]{3}?\z/ }, unless: Proc.new {|c| c.bic.blank?}

  validates :bank_code, numericality: {only_integer: true}, length: { is: 8 }, unless: Proc.new {|c| c.bank_code.blank?}
  validates :bank_account_number, numericality: {only_integer: true}, length: { maximum: 10}, unless: Proc.new {|c| c.bank_account_number.blank?}
  validates :paypal_account, format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/ }, unless: Proc.new {|c| c.paypal_account.blank?}
  validates :paypal_account, presence: true, if: :paypal_validation
  validates :bank_code, :bank_account_number,:bank_name ,:bank_account_owner, :iban,:bic, presence: true, if: :bank_account_validation

  validates :about_me, length: { maximum: 2500, tokenizer: tokenizer_without_html }

  validates_inclusion_of :type, in: ["LegalEntity"], if: :is_ngo?

  monetize :unified_transport_price_cents, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 50000 }, :allow_nil => true
  monetize :unified_transport_cash_on_delivery_price_cents, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 50000 }, :allow_nil => true
  monetize :free_transport_at_price_cents, :numericality => { :greater_than_or_equal_to => 0 }, :allow_nil => true


  ####################################################
  # Methods
  #
  ####################################################

  # Return first_name plus last_name
  # @api public
  # @return [String]
  def fullname
    "#{standard_address_first_name} #{standard_address_last_name}"
  end
  # memoize :fullname

  # Return user nickname
  # @api return
  # @public [String]
  def name
    nickname
  end

  # Return user first name
  # @api return
  # @public [String]
  def first_name
    standard_address_first_name
  end

  # Compare IDs of users
  # @api public
  # @param user [User] Usually current_user
  def is?(user)
    user && self.id == user.id
  end

  # Check if user was created before Sept 24th 2013
  # @api public
  # @param user [User] Usually current_user
  def is_pioneer?
    self.created_at < Time.parse("2013-09-23 23:59:59.000000 CEST +02:00")
  end

  # Static method to get admin status even if current_user is nil
  # @api public
  # @param user [User, nil] Usually current_user
  def self.is_admin?(user)
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
  def image_url(symbol)
    image ? image.image.url(symbol) : ActionController::Base.helpers.asset_path('missing.png')
  end

  # Return a formatted address
  # @api public
  # @return [String]
  def address
    string = ""
    string += "#{standard_address_address_line_1}, "
    string += "#{standard_address_address_line_2}, " if standard_address_address_line_2.present?
    string += "#{standard_address_zip} #{standard_address_city}"
    string
  end

  # Update percentage of positive and negative ratings of seller
  # @api public
  # @return [undefined]
  def update_rating_counter
    number_of_ratings = self.ratings.count

    self.update_attributes( percentage_of_positive_ratings: calculate_percentage_of_biased_ratings( 'positive', 50 ),
                            percentage_of_neutral_ratings:  calculate_percentage_of_biased_ratings( 'neutral', 50 ),
                            percentage_of_negative_ratings: calculate_percentage_of_biased_ratings( 'negative', 50 ) )

    if ( self.is_a?(LegalEntity) && number_of_ratings > 50 ) || ( self.is_a?(PrivateUser) && number_of_ratings > 20 )
      if percentage_of_negative_ratings > 50
        self.banned = true
      end
      update_seller_state
    end
  end

  # Calculates percentage of positive and negative ratings of seller
  # @api public
  # @param bias [String] positive or negative
  # @param limit [Integer]
  # @return [Float]
  def calculate_percentage_of_biased_ratings(bias, limit)
    biased_ratings = { "positive" => 0, "negative" => 0, "neutral" => 0}
    self.ratings.select(:rating).limit(limit).each do |rating|
      biased_ratings[rating.value] += 1
    end
    number_of_considered_ratings = biased_ratings.values.sum
    number_of_biased_ratings = biased_ratings[bias] || 0
    number_of_biased_ratings.fdiv(number_of_considered_ratings) * 100
  end

  # get ngo status
  # @api public
  def is_ngo?
    self.ngo
  end

  # get all users with ngo status but not current
  def self.sorted_ngo_without_current(current_user)
    self.order(:nickname).where("ngo = ? AND id != ?", true, current_user.id)
  end


  ####################################################
  # State Machine
  #
  ####################################################

  state_machine :seller_state, initial: :standard_seller do
    after_transition any => :bad_seller, do: :send_bad_seller_notification

    event :rate_up do
      transition bad_seller: :standard_seller
    end

    event :rate_down_to_bad_seller do
      transition all => :bad_seller
    end

    event :block do
      transition all => :blocked
    end

    event :unblock do
      transition blocked: :standard_seller
    end
  end

  state_machine :buyer_state, initial: :standard_buyer do
    event :rate_up_buyer do
      transition standard_buyer: :good_buyer, bad_buyer: :standard_buyer
    end

    event :rate_down_to_bad_buyer do
      transition all => :bad_buyer
    end
  end

  def send_bad_seller_notification
    RatingMailer.bad_seller_notification(self).deliver
  end

  def buyer_constants
    buyer_constants = {
      not_registered_purchasevolume: 4,
      standard_purchasevolume: 12,
      trusted_bonus: 12,
      good_factor: 2,
      bad_purchasevolume: 6
    }
  end

  def purchase_volume
    purchase_volume = buyer_constants[:standard_purchasevolume]

    purchase_volume += buyer_constants[:trusted_bonus]      if self.trustcommunity
    purchase_volume *= buyer_constants[:good_factor]        if good_buyer?
    purchase_volume = buyer_constants[:bad_purchasevolume]  if bad_buyer?
    purchase_volume
  end

  def bank_account_exists?
    self.bank_code? && self.bank_name? && self.bank_account_number? && self.bank_account_owner? && self.iban? && self.bic?
  end

  def paypal_account_exists?
    self.paypal_account?
  end

  # checks if user passes all neccessary validations before he can sell
  def can_sell?
    self.wants_to_sell = true
    can_sell = self.valid?
    self.wants_to_sell = false
    can_sell
  end

  # Notify the user of an asynchron event
  # @api public
  # @param message [String] Message that is shown to a user
  # @param color [Symbol] see NoticeHelper for the different types of flash notices
  # @param path [String] the Path (relative URL) to which the message should lead the user
  def notify message, path , color = :notice
    unless self.notices.where(message: message, path: path, open: true).any?
      self.notices.create message: message, open: true, path: path, color: color
    end
  end

  # Returns the next open notice of this user
  # @api public
  # @return [Notice] the notice
  def next_notice
    self.notices.where(open: true).first
  end

  # hashes the ip-addresses which are stored by devise :trackable
  def last_sign_in_ip= value
    super Digest::MD5.hexdigest(value)
  end

  def current_sign_in_ip= value
    super Digest::MD5.hexdigest(value)
  end

  # FastBill: this method checks if a user already has fastbill profile
  def has_fastbill_profile?
    fastbill_id && fastbill_subscription_id
  end

  # FastBill
  def update_fastbill_profile
    if self.has_fastbill_profile?
      FastbillAPI.update_profile self
    end
  end

  def count_value_of_goods
    value_of_goods_cents = self.articles.active.sum("price_cents * quantity")
    self.update_attribute(:value_of_goods_cents, value_of_goods_cents)
  end

  # Should work with has_many :article_templates, -> { where(state: :template) }, class_name: 'Article'
  # but it does not!
  def article_templates
    Article.unscoped.where(state: :template, seller: self.id)
  end

  def save_already_validated_standard_address!
    if self.standard_address
      self.standard_address = self.standard_address.duplicate_if_referenced!
      self.standard_address.save!(validate: false) # Already validates with validates_associates in user model
      self.update_column(:standard_address_id, self.standard_address.id)
    end
  end

  def build_standard_address_from address_params
    self.standard_address ||= self.addresses.build if address_params.select{ |param,value| !value.empty? }.any?
    self.standard_address.assign_attributes(address_params) if self.standard_address
  end

  def unified_transport_available?
    self.unified_transport_provider.present? &&
    self.unified_transport_maximum_articles.present? &&
    self.unified_transport_maximum_articles > 1 &&
    self.unified_transport_price_cents.present?
  end

  private

    # @api private
    def create_default_library
      if self.libraries.empty?
        Library.create(name: I18n.t('library.default'), public: false, user_id: self.id)
      end
    end

    def wants_to_sell?
      self.wants_to_sell
    end

    def is_german?
      self.standard_address && self.standard_address.country == "Deutschland"
    end
end
