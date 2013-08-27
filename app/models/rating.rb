class Rating < ActiveRecord::Base
  extend Enumerize


  attr_accessible :rating, :rated_user_id, :text, :transaction_id

  belongs_to :transaction
  belongs_to :rated_user, class_name: 'User'
  has_one :rating_user, through: :transaction, source: :buyer
  enumerize :rating, in: [:positive, :neutral, :negative]

  after_save :update_ratings_in_user

  private
    def update_ratings_in_user
      rated_user.update_ratings
    end
end
