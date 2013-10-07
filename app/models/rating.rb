class Rating < ActiveRecord::Base
  extend Enumerize

  attr_accessible :rating, :rated_user_id, :text, :transaction_id

  belongs_to :transaction
  belongs_to :rated_user, class_name: 'User'
  has_one :rating_user, through: :transaction, source: :buyer
  enumerize :rating, in: [:positive, :neutral, :negative]
  delegate :update_rating_counter, to: :rated_user

  after_save :update_rating_counter
end
