class AddNewTermsConfirmedToUser < ActiveRecord::Migration
  def change
    add_column :users, :new_terms_confirmed, :boolean, :default => false
  end
end
