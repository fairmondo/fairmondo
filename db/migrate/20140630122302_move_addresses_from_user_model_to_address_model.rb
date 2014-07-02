class MoveAddressesFromUserModelToAddressModel < ActiveRecord::Migration
  def up
    User.find_each do |user|
      std_add = user.addresses.build(
        title: user.title,
        first_name: user.forename,
        last_name: user.surname,
        company_name: user.company_name,
        address_line_1: user.street,
        address_line_2: user.address_suffix,
        zip: user.zip,
        city: user.city,
        country: user.country
      )
      std_add.save
      std_add.reload
      user.update(standard_address_id: std_add.id)

      user.bought_business_transactions.find_each do |bt|
        new_address = true
        address = nil

        user.addresses.find_each do |add|
          if (add.first_name == bt.forename) &&
              (add.last_name == bt.surname) &&
                (add.address_line_1 == bt.street) &&
                  (add.address_line_2 == bt.address_suffix) &&
                    (add.zip == bt.zip) &&
                      (add.city == bt.city) &&
                        (add.country == bt.country)

            new_address = false
            address = add
          end
        end

        if new_address
          address = user.addresses.build(
            first_name: bt.forename,
            last_name: bt.surname,
            address_line_1: bt.street,
            address_line_2: bt.address_suffix,
            zip: bt.zip,
            city: bt.city,
            country: bt.country
          )
          address.save
          address.reload
        end

        bt.update_column(:shipping_address_id, address.id)
        bt.update_column(:billing_address_id, address.id)
      end
    end

    remove_column :users, :title
    remove_column :users, :forename
    remove_column :users, :surname
    remove_column :users, :street
    remove_column :users, :address_suffix
    remove_column :users, :zip
    remove_column :users, :company_name
    remove_column :users, :city
    remove_column :users, :country

    remove_column :business_transactions, :forename
    remove_column :business_transactions, :surname
    remove_column :business_transactions, :street
    remove_column :business_transactions, :address_suffix
    remove_column :business_transactions, :zip
    remove_column :business_transactions, :city
    remove_column :business_transactions, :country
  end
end
