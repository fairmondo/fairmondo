ActiveAdmin.register Ffp , :as => "Fair Founding Points" do
  index do
    column :donator do |donator|
        link_to donator.email, admin_user_path(donator)
    end
    column "Donation Amount" , :price do |price|
      humanized_money_with_symbol price
    end
    column "Confirmed", :activated
    default_actions
  end
end
