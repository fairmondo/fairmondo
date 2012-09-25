class CreateUserevents < ActiveRecord::Migration
  def change
    create_table :userevents do |t|

      t.timestamps
    end
  end
end
