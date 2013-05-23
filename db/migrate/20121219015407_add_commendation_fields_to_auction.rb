class AddCommendationFieldsToAuction < ActiveRecord::Migration
  def change
    # fair fields part 1
    add_column :auctions, :fair, :boolean, :default => false
    add_column :auctions, :fair_kind, :string
    add_column :auctions, :fair_seal, :string

    # ecologic fields
    add_column :auctions, :ecologic, :boolean, :default => false
    add_column :auctions, :ecologic_seal, :string

    # small and precious fields
    add_column :auctions, :small_and_precious, :boolean, :default => false
    add_column :auctions, :small_and_precious_edition, :integer
    add_column :auctions, :small_and_precious_reason, :text
    add_column :auctions, :small_and_precious_handmade, :boolean, :default => false

  end
end
