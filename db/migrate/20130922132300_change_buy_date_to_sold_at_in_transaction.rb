class ChangeBuyDateToSoldAtInTransaction < ActiveRecord::Migration[4.2]
  def change
  	rename_column :transactions, :buy_date, :sold_at
  end
end
