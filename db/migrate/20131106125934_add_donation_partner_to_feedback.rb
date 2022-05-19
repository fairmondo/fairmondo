class AddDonationPartnerToFeedback < ActiveRecord::Migration[4.2]
  def change
    add_column :feedbacks, :forename, :string
    add_column :feedbacks, :lastname, :string
    add_column :feedbacks, :organisation, :string
    add_column :feedbacks, :phone, :string
  end
end
