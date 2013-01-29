class UpdatePaymentEntries < ActiveRecord::Migration
  def up
    # without adoption, loading the record results in 
    # ActiveRecord::SerializationTypeMismatch: Attribute was supposed to be a Array, but was a String
    Auction.update_all("payment = '[' + payment + ']'","payment NOT LIKE '%[%]%'")
  end

  def down
  end
end
