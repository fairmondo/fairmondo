#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class Address < ActiveRecord::Base
  belongs_to :user
  has_one :connected_user, class_name: 'User', foreign_key: :standard_address_id, inverse_of: :standard_address

  has_many :payment_address_references, class_name: 'LineItemGroup', foreign_key: :payment_address_id, inverse_of: :payment_address
  has_many :transport_address_references, class_name: 'LineItemGroup', foreign_key: :transport_address_id, inverse_of: :transport_address

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :address_line_1, presence: true, format: /\A.+\d+.*\z/ # format: ensure digit for house number
  validates :address_line_2, length: { maximum: 150 }
  validates :zip, presence: true, zip: true, length: { maximum: 5 }
  validates :city, presence: true, length: { maximum: 150 }
  validates :country, presence: true, length: { maximum: 150 }

  extend Sanitization

  auto_sanitize :title, :first_name, :last_name, :address_line_1, :address_line_2, :zip, :city, :country

  amoeba do
    enable
    exclude_association :payment_address_references
    exclude_association :transport_address_references
    exclude_association :connected_user
  end

  attr_accessor :set_as_standard_address

  # if the record is referenced somewhere we need to
  # duplicate and stash it
  def duplicate_if_referenced!
    if self.changed_attributes.any? && self.is_referenced?
      new_address = self.amoeba_dup
      new_address.set_as_standard_address = true if self.is_standard_address?
      self.stash!
      return new_address
    end
    return self
  end

  def stash!
    self.update_column(:stashed, true)
  end

  def is_referenced?
    self.payment_address_references.any? || self.transport_address_references.any?
  end

  def is_standard_address?
    connected_user.present?
  end
end
