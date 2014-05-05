class SearchRefinery < ApplicationRefinery
  def default
    [
      :q, :fair, :ecologic, :small_and_precious, :condition,
      :category_id, :zip, :order_by, :search_in_content
    ]
  end
end