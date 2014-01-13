class RefundPolicy < Struct.new( :user, :refund )
  def create?
    own? && refund_possible? 
  end

  def new?
    create?
  end

  private
    def own?
      user.id == refund.transaction_seller.id
    end

    # this method checks if the transaction is in a state in which it is possible
    # for it to request a refund
    # The construction of the statement seems a bit odd, as it checks on an instance
    # of Refund itself, this is possible as Refund.create creates a new instance which
    # is not yet saved to the db and as such has no association with a transaction
    # instance
    #
    def refund_possible?
      refund.transaction.sold? && !refund.transaction.requested_refund?
    end
end
