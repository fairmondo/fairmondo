class ChangeBodyFromTinycms < ActiveRecord::Migration
  def self.up
    change_table :tinycms_contents do |t|
      t.change :body, :text
    end
  end

  def self.down
    change_table :tinycms_contents do |t|
      t.change :body, :string
    end
  end
end
