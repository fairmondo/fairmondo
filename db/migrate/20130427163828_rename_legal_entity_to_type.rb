class RenameLegalEntityToType < ActiveRecord::Migration
  
  class User < ActiveRecord::Base
    
  end
  
  def up
    add_column :users , :type , :string
    User.reset_column_information
    User.all.each do |user|
      if user.legal_entity?
        user.type = "LegalEntity"
      else
        user.type = "PrivateUser"
      end
      user.save!
    end
    remove_column :users , :legal_entity
  end

  def down
     add_column:users , :legal_entity, :boolean
     User.reset_column_information
      User.all.each do |user|
        if user.type=="LegalEntity"
          user.legal_entity = true
        else
          user.legal_entity = false
        end
        user.save!
      end
     remove_column :users , :type
  end
end
