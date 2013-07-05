class TransformTinyCms < ActiveRecord::Migration
  def change
    rename_table :tinycms_contents, :contents

    rename_index :tinycms_contents, 'index_tinycms_contents_on_key', 'index_contents_on_key'
  end
end
