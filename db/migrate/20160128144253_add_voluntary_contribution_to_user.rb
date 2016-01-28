class AddVoluntaryContributionToUser < ActiveRecord::Migration
  def change
    add_column :users, :voluntary_contribution, :integer
  end
end
