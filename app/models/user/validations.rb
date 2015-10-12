#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module User::Validations
  extend ActiveSupport::Concern

  included do
    validates :slug, presence: true

    # Registration validations
    validates :type, inclusion: { in: %w(PrivateUser LegalEntity) }
    validates :nickname, presence: true, uniqueness: true
    validates :legal, acceptance: true, on: :create
    validates_associated :standard_address, unless: Proc.new { |u| u.encrypted_password_changed? }

    with_options if: :wants_to_sell? do |seller|
      seller.validates :standard_address, presence: true
    end

    # TODO: Language specific validators
    # german validator for iban
    validates :iban, format: { with: /\A[A-Za-z]{2}[0-9]{2}[A-Za-z0-9]{18}\z/ }, unless: Proc.new { |c| c.iban.blank? }, if: :is_german?
    validates :bic, format: { with: /\A[A-Za-z]{4}[A-Za-z]{2}[A-Za-z0-9]{2}[A-Za-z0-9]{3}?\z/ }, unless: Proc.new { |c| c.bic.blank? }

    validates :paypal_account, format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/ }, unless: Proc.new { |c| c.paypal_account.blank? }
    validates :paypal_account, presence: true, if: :paypal_validation
    validates :bank_account_owner, :iban, :bic, presence: true, if: :bank_account_validation

    validates :about_me, length: { maximum: 2500, tokenizer: tokenizer_without_html }

    validates :type, inclusion: { in: ['LegalEntity'] }, if: :is_ngo?
  end
end
