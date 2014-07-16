class RatingRefinery < ApplicationRefinery

  def default
    [ :rating, :rated_user_id, :text, :line_item_group_id ]
  end
end
