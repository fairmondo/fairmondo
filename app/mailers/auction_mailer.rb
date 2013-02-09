class AuctionMailer < ActionMailer::Base
  default from: "info@fairnopoly.de"
  
  def report_auction(auction,text)
    mail(:to => "melden@fairnopoly.de", :subject => "Auction reported with ID: " + auction.id.to_s, :body => text)
  end
  
  def category_proposal(category_proposal)
    mail(:to => "kundenservice@fairnopoly.de", :subject => "Category proposal: " + category_proposal)
  end
  
end