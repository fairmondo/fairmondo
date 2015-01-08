class BusinessTransactionPolicy < Struct.new(:user, :business_transaction)

  def set_transport_ready?
    own?
  end

  private

    def own?
      user && business_transaction.seller == user
    end
end
