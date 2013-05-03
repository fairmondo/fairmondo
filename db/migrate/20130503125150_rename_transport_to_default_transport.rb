class RenameTransportToDefaultTransport < ActiveRecord::Migration
  def change
    rename_column :auctions, :transport, :default_transport
  end
end
