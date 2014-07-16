class AddLibraryReferenceToComments < ActiveRecord::Migration
  def change
    add_reference :comments, :library, index: true
  end
end
