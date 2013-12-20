class RefundPolicy < Struct.new(:user, :refund)
  def create?
                #t = Transaction.find(refund.transaction.id)
    own? && refund.transaction.sold? && !refund.transaction.reload.requested_refund?
  end

  def new?
    create?
  end

  private
    def own?
      user.id == refund.transaction_seller.id
    end
end
