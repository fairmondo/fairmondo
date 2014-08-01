class BusinessTransactionPolicy < Struct.new(:user, :business_transaction)
  def show?
    true # as it will only redirect you it will be checked in line_item_grouppolicy
  end
end
