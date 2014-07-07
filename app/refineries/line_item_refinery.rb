class LineItemRefinery < ApplicationRefinery
  def create
    [ :article_id, :requested_quantity ]
  end

  def update
    [ :requested_quantity ]
  end
end
