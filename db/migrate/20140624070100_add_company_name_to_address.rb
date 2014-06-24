class AddCompanyNameToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :company_name, :string
  end
end
