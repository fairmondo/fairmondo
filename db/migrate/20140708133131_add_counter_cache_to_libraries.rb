class AddCounterCacheToLibraries < ActiveRecord::Migration
  def self.up
    say_with_time "Adding Hearts counter cache to libraries" do
      add_column :libraries, :hearts_count, :integer, :default => 0

      Library.reset_column_information
      Library.all.each do |l|
        l.update_attribute :hearts_count, l.hearts.length
      end
    end
  end

  def self.down
    say_with_time "Removing Hearts counter cache from libraries" do
      remove_column :libraries, :hearts_count
    end
  end
end
