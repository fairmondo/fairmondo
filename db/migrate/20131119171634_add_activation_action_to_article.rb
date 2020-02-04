class AddActivationActionToArticle < ActiveRecord::Migration[4.2]
  def change
    add_column :articles, :activation_action, :string
  end
end
