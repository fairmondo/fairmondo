class CreateSocialProducerQuestionnaire < ActiveRecord::Migration
  def up
    create_table :social_producer_questionnaires do |t|
      t.integer :auction_id
      
      t.boolean :nonprofit_association, :default => true
      t.text :nonprofit_association_purposes
      
      t.boolean :social_businesses_muhammad_yunus, :default => true
      t.text :social_businesses_muhammad_yunus_purposes
      
      t.boolean :social_entrepreneur, :default => true
      t.text :social_entrepreneur_purposes
    end
  end

  def down
    drop_table :social_producer_questionnaires
  end
end
