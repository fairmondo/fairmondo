class AddAppendedObjectIdToUserevents < ActiveRecord::Migration
  def change
    add_column :userevents, :appended_object_id, :integer
    add_column :userevents, :appended_object_type, :string

  end
end
