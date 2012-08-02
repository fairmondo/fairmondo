class WelcomeController < ApplicationController
  
  
  def index
    @ffps_user = 0
    if user_signed_in? 
      @ffps_user = @ffp_amount = current_user.ffps.sum(:price)
    end
    
    #calculate the ffp amount over all ffps
    @ffp_amount = Ffp.sum(:price)
    # calculate the persentage from 50000
    @persent = (@ffp_amount.to_f/50000.0)*100.0 
  end
  
end
