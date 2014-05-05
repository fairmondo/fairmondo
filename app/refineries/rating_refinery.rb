class RatingRefinery < ApplicationRefinery

  def default
    [ :rating, :rated_user_id, :text, :transaction_id ]
  end
end
