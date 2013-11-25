class AddActivationActionToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :activation_action, :string
  end
end
