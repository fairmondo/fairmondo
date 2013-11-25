class Refund < ActiveRecord::Migration
  def change
    create_table :refunds do |t|
      t.string :refund_reason
      t.text :refund_description
 
      t.timestamps
    end
  end
end
