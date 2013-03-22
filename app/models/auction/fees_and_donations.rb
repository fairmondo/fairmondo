module Auction::FeesAndDonations
  extend ActiveSupport::Concern

  AUCTION_FEES = {
    :min => 0.1,
    :max => 35.0,
    :fair => 0.03,
    :default => 0.06
  }

  included do
    
    attr_accessible :calculated_corruption_cents, :calculated_friendly_cents, :calculated_fee_cents,:friendly_percent, :friendly_percent_organisation
    
    # Fees and donations
    monetize :calculated_corruption_cents
    monetize :calculated_friendly_cents
    monetize :calculated_fee_cents

     ## friendly percent
  
    validates_numericality_of :friendly_percent, :greater_than_or_equal_to => 0.0, :less_than_or_equal_to => 99.0, :only_integer => true
    enumerize :friendly_percent_organisation, :in => [:transparency_international], :default => :transparency_international
    validates_presence_of :friendly_percent_organisation, :if => :friendly_percent
    

  end
  
   ## -------------- Calculate Fees And Donations ---------------
  
 def friendly_percent_calculated
    friendly_percent_result
  end
  
  def calculated_fees_and_donations
    self.calculated_corruption + self.calculated_friendly + self.calculated_fee
  end
    
  def calculate_fees_and_donations
    self.calculated_corruption  = corruption_percent_result
    self.calculated_friendly = friendly_percent_result
    self.calculated_fee = fee_result
  end   
  
private  
    
  def friendly_percent_result
    if self.friendly_percent
      self.price * (self.friendly_percent / 100.0)
    else
      Money.new(0)
    end
  end
  
  ## fees and donations
  
  def corruption_percentage
    0.01
  end
  
  def corruption_percent_result
    self.price * corruption_percentage
  end
  
  
  def fee_percentage
    if fair?
      AUCTION_FEES[:fair]
    else
      AUCTION_FEES[:default]
    end
  end
  
  def fee_result
    r = self.price * fee_percentage
    min = Money.new(AUCTION_FEES[:min]*100)
    r = min if r < min
    max = Money.new(AUCTION_FEES[:max]*100)
    r = max if r > max
    r
  end
   
  
  
end