#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module Article::Validations
  extend ActiveSupport::Concern

  included do
    extend Tokenize

    before_validation :set_sellers_nested_validations
    before_validation :ensure_no_redundant_categories # just store the leafs to avoid inconsistencies

    validates :user_id, presence: true
    validates :slug, presence: true, if: :should_get_a_slug?

    validates :title,
              length: { minimum: 6, maximum: 200 }, presence: true
    validates :content,
              length: { maximum: 10000, tokenizer: tokenizer_without_html },
              presence: true
    validates :article_template_name,
              uniqueness: { scope: [:seller] }, presence: true,
              if: Proc.new { |a| a.is_template? || a.save_as_template? }

    validates :categories,
              size: { in: 1..2, add_errors_to: [:categories, :category_ids] }

    validates :condition, presence: true
    validates :condition_extra, presence: true, if: :old?

    # money_rails and price
    validates :price_cents, presence: true, numericality: {
      greater_than_or_equal_to: 0, less_than_or_equal_to: 1000000
    }

    validates :vat, presence: true, inclusion: { in: [0, 7, 19] },
                    if: :belongs_to_legal_entity?
    validates :basic_price_cents, numericality: {
      greater_than_or_equal_to: 0, less_than_or_equal_to: 1000000
    }, allow_nil: false

    validates :basic_price_amount, presence: true, if: lambda { |obj| obj.basic_price_cents && obj.basic_price_cents > 0 }

    # legal entity attributes

    validates :custom_seller_identifier, length: { maximum: 65 }, allow_nil: true, allow_blank: true
    validates :gtin, length: { minimum: 8, maximum: 14 }, allow_nil: true, allow_blank: true

    # transport

    validates :transport_type1_provider, :transport_type2_provider, length: { maximum: 255 }
    validates :transport_type1_price, :transport_type1_provider, presence: true, if: :transport_type1
    validates :transport_type2_price, :transport_type2_provider, presence: true, if: :transport_type2
    validates :transport_type1_number, :transport_type2_number, numericality: { greater_than: 0 }
    validates :transport_bike_courier_number, numericality: { greater_than: 0 }, if: :transport_bike_courier
    validates :transport_details, length: { maximum: 2500 }
    validates :transport_time, length: { maximum: 7 }, format: { with: /\A\d{1,2}[-–]?\d{,2}\z/ }, allow_blank: true

    # payment

    validates :payment_cash_on_delivery_price, presence: true, if: :payment_cash_on_delivery
    validates :payment_details, length: { maximum: 2500 }
    validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10000 }
    validates :quantity_available, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10000 }
    validates :tos_accepted, acceptance: true, presence: true, on: :update, if: lambda { |art| art.changing_state && art.belongs_to_legal_entity? }

    # images

    validates :images, size: { in: 0..5  } # lower to 3 if the old 5 article pics are all gone

    # custom validations

    validate :payment_method_checked
    validate :transport_method_checked
    validate :bank_account_exists, if: :payment_bank_transfer
    validate :bank_transfer_available, if: :payment_bank_transfer
    validate :paypal_account_exists, if: :payment_paypal
    validate :only_one_title_image
    validate :bike_courier_requires_paypal, if: :transport_bike_courier
    validate :right_zip_for_courier, if: :transport_bike_courier
  end

  private

  def set_sellers_nested_validations
    seller.bank_account_validation = true if payment_bank_transfer
    seller.paypal_validation = true if payment_paypal
  end

  def ensure_no_redundant_categories
    self.category_ids =  categories.reject { |c| categories.any? { |other| c != nil && other.is_descendant_of?(c) } }.uniq { |c| c.id }.map(&:id) if self.categories
    true
  end

  def transport_method_checked
    unless self.transport_pickup || self.transport_type1 || self.transport_type2 || self.transport_bike_courier
      errors.add(:transport_details, I18n.t('article.form.errors.invalid_transport_option'))
    end
  end

  def payment_method_checked
    unless self.payment_bank_transfer || self.payment_paypal ||
           self.payment_cash || self.payment_cash_on_delivery ||
           self.payment_invoice || self.payment_voucher
      errors.add(:payment_details, I18n.t('article.form.errors.invalid_payment_option'))
    end
  end

  def bank_account_exists
    unless self.seller.bank_account_exists?
      errors.add(:payment_bank_transfer, I18n.t('article.form.errors.bank_details_missing'))
    end
  end

  def paypal_account_exists
    unless self.seller.paypal_account_exists?
      errors.add(:payment_paypal, I18n.t('article.form.errors.paypal_details_missing'))
    end
  end

  def bank_transfer_available
    if self.seller.created_at > 1.month.ago && self.price_cents >= 10000 && self.seller.type == 'PrivateUser'
      errors.add(:payment_bank_transfer, I18n.t('article.form.errors.bank_transfer_not_allowed'))
    end
  end

  def only_one_title_image
    count_images = 0
    self.images.each do |image|
      count_images += 1 if image.is_title
    end
    if count_images > 1
      errors.add(:images, I18n.t('article.form.errors.only_one_title_image'))
    end
  end

  def bike_courier_requires_paypal
    unless self.transport_bike_courier && self.payment_paypal
      errors.add(:payment_details, I18n.t('article.form.errors.invalid_payment_for_bike_courier'))
    end
  end

  def right_zip_for_courier
    unless COURIER['zip'].include? self.seller.standard_address_zip
      errors.add(:transport_bike_courier, I18n.t('article.form.errors.wrong_zip_for_bike_transport'))
    end
  end
end
