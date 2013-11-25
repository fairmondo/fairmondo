class CreateMassUploads < ActiveRecord::Migration
  def change
    create_table :mass_uploads do |t|
      t.integer :article_count
      t.integer :character_count, :default => 0
      t.text    :failure_reason
      t.integer :user_id

      t.timestamps
    end
  end
end
