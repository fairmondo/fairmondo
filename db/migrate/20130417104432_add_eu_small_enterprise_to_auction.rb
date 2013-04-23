class AddEuSmallEnterpriseToAuction < ActiveRecord::Migration
  def change
     add_column :auctions, :small_and_precious_eu_small_enterprise, :boolean
    
  end
end
