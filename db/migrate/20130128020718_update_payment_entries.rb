class UpdatePaymentEntries < ActiveRecord::Migration
  class Auction < ActiveRecord::Base
    
  end
  def up
    Auction.reset_column_information
    # without adoption, loading the record results in 
    # ActiveRecord::SerializationTypeMismatch: Attribute was supposed to be a Array, but was a String
    Auction.unscoped {
      Auction.all(:conditions => ["not(payment  LIKE ?)","[%]"]).each do |auction|
        auction.payment = "[" + auction.payment.to_s + "]"
        auction.save(validate: false)
      end
    }
  end

  def down
  end
end
