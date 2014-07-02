class LineItemGroupRefinery < ApplicationRefinery
  def root
    false # LineItems don't have forms, they get controlled
  end

  def update
    [ :unified_transport,:unified_payment, :unified_payment_method ]
  end
end
