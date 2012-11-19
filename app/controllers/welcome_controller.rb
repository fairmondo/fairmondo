class WelcomeController < ApplicationController

  before_filter :build_login
  def index
    @auctions = Auction.count
    @percentage = (@auctions.to_f/10000.0)*100.0
  end

end
