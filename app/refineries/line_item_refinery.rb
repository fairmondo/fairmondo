class LineItemRefinery < ApplicationRefinery
  def root
    false # LineItems don't have forms, they get controlled
  end

  def create
    [ :article_id ]
  end
end
