class AddVoluntaryContributionToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :voluntary_contribution, :integer
  end
end
