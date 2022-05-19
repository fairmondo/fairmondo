class AddFailingReasonToImages < ActiveRecord::Migration[4.2]
  def up
    add_column :images, :failing_reason, :string
  end
  def down
    remove_column :images, :failing_reason
  end
end
