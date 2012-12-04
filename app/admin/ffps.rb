ActiveAdmin.register Ffp do
  filter :price
  menu :label => 'Fair Founding Points'
  index :title => 'Fair Founding Points' do
    column :donator do |donator|
      link_to "donator.email", admin_user_path(donator)
    end
    column "Donation Amount" , :price do |ffp|
      humanized_money_with_symbol ffp.price
    end

    column "Payment" do |ffp|
      if ffp.activated?
        "Confirmed"
      else
        link_to "Confirm", confirm_admin_ffp_path(ffp)
      end
    end
    default_actions

  end

  member_action :confirm do
  # your normal action code
    ffp = Ffp.find(params[:id])
    ffp.activated = true

    Notification.send_ffp_confirmed(ffp).deliver
    redirect_to :back,  :notice => 'Payment confirmed.'

  end

end
