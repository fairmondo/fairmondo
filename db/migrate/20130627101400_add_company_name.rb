class AddCompanyNameToUser < ActiveRecord::Migration
  def change
    add_column :users, :company_name, :string
  end
end
