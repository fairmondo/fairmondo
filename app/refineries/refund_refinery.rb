class RefundRefinery < ApplicationRefinery

  def default
    [ :reason, :description ]
  end
end
