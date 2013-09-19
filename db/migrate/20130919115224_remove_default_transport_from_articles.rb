class RemoveDefaultTransportFromArticles < ActiveRecord::Migration
  def up
    remove_column :articles, :default_transport
  end

  def down
    add_column :articles, :default_transport, :string
  end
end
