class RefundPolicy < Struct.new(:user, :transaction)
  def show?
    own? && transaction.sold?
  end

  def create?
    own? && transaction.sold?
  end

  private
    def own?
      user.id == transaction.seller_id
    end
end
