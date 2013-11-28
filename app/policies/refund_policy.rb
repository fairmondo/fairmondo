class RefundPolicy < Struct.new(:user, :refund)
  def create?
    own? && refund.transaction.sold? && !refund.transaction.requested_refund? 
  end
  
  def new?
    create?
  end

  private
    def own?
      user.id == refund.transaction_seller.id
    end
end
