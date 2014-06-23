class Cart < ActiveRecord::Base
  has_many :line_item_groups, dependent: :destroy
  belongs_to :user

  scope :newest , -> { order(created_at: :desc) }
  scope :open , -> { where.not(sold: true) }

end
