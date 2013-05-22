module Article::FeesAndDonations
  extend ActiveSupport::Concern

  AUCTION_FEES = {
    :max => 35.0,
    :fair => 0.03,
    :default => 0.06
  }

  included do

    attr_accessible :calculated_corruption_cents, :calculated_friendly_cents, :calculated_fee_cents,:friendly_percent, :friendly_percent_organisation

    # Fees and donations
    monetize :calculated_corruption_cents, :allow_nil => true
    monetize :calculated_friendly_cents, :allow_nil => true
    monetize :calculated_fee_cents, :allow_nil => true

     ## friendly percent

    validates_numericality_of :friendly_percent, :greater_than_or_equal_to => 0.0, :less_than_or_equal_to => 100, :only_integer => true
    enumerize :friendly_percent_organisation, :in => [:transparency_international], :default => :transparency_international
    validates_presence_of :friendly_percent_organisation, :if => :friendly_percent


  end

   ## -------------- Calculate Fees And Donations ---------------

  # def friendly_percent_calculated
  #   Money.new(friendly_percent_result_cents)
  # end

  def calculated_fees_and_donations
    self.calculated_corruption + self.calculated_friendly + self.calculated_fee
  end

  def calculate_fees_and_donations
    self.calculated_friendly = Money.new(friendly_percent_result_cents)
    if self.friendly_percent < 100 && self.price > 0
      self.calculated_corruption  = corruption_percent_result
      self.calculated_fee = fee_result
    else
      self.calculated_corruption  = 0
      self.calculated_fee = 0
    end
  end


private

  def friendly_percent_result_cents
    # At the moment there is no friendly percent
    # for rounding -> do always up rounding (e.g. 900,1 cents are 901 cents)
    #(self.price_cents * (self.friendly_percent / 100.0)).ceil
    0
  end

  ## fees and donations

  def corruption_percentage
    0.01
  end

  def corruption_percent_result
    # for rounding -> do always up rounding (e.g. 900,1 cents are 901 cents)
    Money.new(((self.price_cents - friendly_percent_result_cents) * corruption_percentage).ceil)
  end

  def fee_percentage
    if fair?
      AUCTION_FEES[:fair]
    else
      AUCTION_FEES[:default]
    end
  end

  def fee_result
    # for rounding -> do always up rounding (e.g. 900,1 cents are 901 cents)
    r = Money.new(((self.price_cents - friendly_percent_result_cents) * fee_percentage).ceil)
    max = Money.new(AUCTION_FEES[:max]*100)
    r = max if r > max
    r
  end

end