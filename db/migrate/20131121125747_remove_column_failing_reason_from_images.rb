class RemoveColumnFailingReasonFromImages < ActiveRecord::Migration
  def change
    remove_column :images, :failing_reason
  end
end
