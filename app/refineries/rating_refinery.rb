class RatingRefinery < ApplicationRefinery

  def default
    [ :rating, :rated_user_id, :text, :business_transaction_id ]
  end
end
