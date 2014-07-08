class Heart < ActiveRecord::Base
  belongs_to :user
  belongs_to :heartable, polymorphic: true

  validates :user, presence: true, uniqueness: { scope: [:heartable_id, :heartable_type] }
  validates :heartable, presence: true
end