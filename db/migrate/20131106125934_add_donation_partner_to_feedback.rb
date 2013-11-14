class AddDonationPartnerToFeedback < ActiveRecord::Migration
  def change
    add_column :feedbacks, :forename, :string
    add_column :feedbacks, :lastname, :string
    add_column :feedbacks, :organisation, :string
    add_column :feedbacks, :phone, :string
  end
end
