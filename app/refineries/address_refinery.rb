class AddressRefinery < ApplicationRefinery
  def default
    [:title, :first_name, :last_name, :address_line_1, :address_line_2, :city, :zip, :country, :user_id]
  end
end
