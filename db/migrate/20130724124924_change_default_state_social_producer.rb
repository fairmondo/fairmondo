class ChangeDefaultStateSocialProducer < ActiveRecord::Migration[4.2]
  def up
    change_column :social_producer_questionnaires ,:nonprofit_association, :boolean , :default => false
    change_column :social_producer_questionnaires ,:social_businesses_muhammad_yunus, :boolean , :default => false
    change_column :social_producer_questionnaires ,:social_entrepreneur, :boolean , :default => false
  end

  def down
    change_column :social_producer_questionnaires ,:nonprofit_association, :boolean , :default => true
    change_column :social_producer_questionnaires ,:social_businesses_muhammad_yunus, :boolean , :default => true
    change_column :social_producer_questionnaires ,:social_entrepreneur, :boolean , :default => true
  end
end
