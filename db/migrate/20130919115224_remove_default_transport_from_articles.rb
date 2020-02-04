class RemoveDefaultTransportFromArticles < ActiveRecord::Migration[4.2]
  def up
    remove_column :articles, :default_transport
  end

  def down
    add_column :articles, :default_transport, :string
  end
end
