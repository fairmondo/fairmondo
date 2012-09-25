class EventTypeToUserevent < ActiveRecord::Migration
  def change
    add_column :userevents, :event_type, :integer

  end
end
