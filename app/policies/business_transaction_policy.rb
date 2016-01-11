#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class BusinessTransactionPolicy < Struct.new(:user, :business_transaction)
  def set_transport_ready?
    own?
  end

  private

  def own?
    user && business_transaction.seller == user
  end
end
