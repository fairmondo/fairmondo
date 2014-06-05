class AddressRefinery < ApplicationRefinery

  def default
    [:first_name, :last_name, :address_line_1, :address_line_2, :city, :zip, :country]
  end
end
