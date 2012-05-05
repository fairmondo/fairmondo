class DashboardController < ApplicationController
  
  before_filter :authenticate_user!
  # GET /auctions
  # GET /auctions.json
  def index
       @auctions = Auction.all

      respond_to do |format|
        format.html # index.html.erb
        format.json { render :json => @auctions }
      end
  end
end