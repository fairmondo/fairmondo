class AddCommentCounterCacheToLibraries < ActiveRecord::Migration
  def self.up
    say_with_time "Adding Comments counter cache to libraries" do
      add_column :libraries, :comments_count, :integer, default: 0

      Library.reset_column_information
      Library.all.each do |l|
        l.update_attribute :comments_count, l.comments.length
      end
    end
  end

  def self.down
    say_with_time "Removing Comments counter cache from libraries" do
      remove_column :libraries, :comments_count
    end
  end
end
