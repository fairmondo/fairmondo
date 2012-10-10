ActiveAdmin.register User do
  index do
    column :id
    column :email
    column "Name" do |user|
      user.name + " " + user.surname
    end
    column "Trustcommiunity" do |user|
      if user.trustcommunity? && user.invitor != nil
        "Member"
      elsif user.trustcommunity? && user.invitor == nil
        "Founder"
      else
        link_to "Join as Founder", trustcommunity_admin_user_path(user)
      end 
    end
    column :admin
    default_actions
  end
  
   member_action :trustcommunity do
    # your normal action code
    user = User.find(params[:id])
    user.trustcommunity = true
    user.save
    redirect_to(:back)
  end
  
  
end
