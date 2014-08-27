class Heart < ActiveRecord::Base
  belongs_to :user
  belongs_to :heartable, polymorphic: true, counter_cache: true

  validates :heartable, presence: true

  validates :user,
            presence: true,
            uniqueness: { scope: [:heartable_id, :heartable_type] },
            unless: -> { user_token.present? }

  validates :user_token,
            presence: true,
            uniqueness: { scope: [:heartable_id, :heartable_type] },
            unless: -> { user.present? }
end
