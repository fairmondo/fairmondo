class RemoveColumnFailingReasonFromImages < ActiveRecord::Migration[4.2]
  def change
    remove_column :images, :failing_reason
  end
end
