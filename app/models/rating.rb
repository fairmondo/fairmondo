class Rating < ActiveRecord::Base
  extend Enumerize

  def self.rating_attrs
    [:rating, :rated_user_id, :text, :transaction_id]
  end

  belongs_to :transaction
  belongs_to :rated_user, class_name: 'User', inverse_of: :ratings
  has_one :rating_user, through: :transaction, source: :buyer, inverse_of: :given_ratings
  enumerize :rating, in: [:positive, :neutral, :negative]
  delegate :update_rating_counter, to: :rated_user

  validates :rating, :rated_user_id, :transaction_id, presence: true
  validates :text, :length => { :maximum => 2500 }
  # auto_sanitize :text
  validates :transaction_id, :uniqueness => true, presence: true

  after_save :update_rating_counter
  alias :value :rating # to avoid structure 'rating_rating' in shared/show_transaction

end
