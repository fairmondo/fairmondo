class AddFailingReasonToImages < ActiveRecord::Migration
  def up
    add_column :images, :failing_reason, :string
  end
  def down
    remove_column :images, :failing_reason
  end
end
