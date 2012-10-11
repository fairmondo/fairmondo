class WelcomeController < ApplicationController
  
  
  def index
    
    #TODO: check if we really want to do like this
    @ffps_user = 0
    if user_signed_in? 
      @ffps_user = @ffp_amount = current_user.ffps.sum(:price)
    end
    
    #calculate the ffp amount over all ffps
    @ffp_amount = Ffp.sum(:price, :conditions => ["activated = ?",true])
    # calculate the persentage from 50000
    @persent = (@ffp_amount.to_f/50000.0)*100.0 
    
  end
  
end
