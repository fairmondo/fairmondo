#
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
module Article::FeesAndDonations
  extend ActiveSupport::Concern

  AUCTION_FEES = {
    :max_fair => 15.0,
    :max_default => 30.0,
    :fair => 0.03,
    :default => 0.06
  }

  included do

    attr_accessible :calculated_fair_cents, :calculated_friendly_cents, :calculated_fee_cents,:friendly_percent, :friendly_percent_organisation

    # Fees and donations
    monetize :calculated_fair_cents, :allow_nil => true
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
    self.calculated_fair + self.calculated_friendly + self.calculated_fee
  end

  def calculate_fees_and_donations
    self.calculated_friendly = Money.new(friendly_percent_result_cents)
    if self.friendly_percent < 100 && self.price > 0
      self.calculated_fair  = fair_percent_result
      self.calculated_fee = fee_result
    else
      self.calculated_fair  = 0
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

  def fair_percentage
    0.01
  end

  def fair_percent_result
    # for rounding -> do always up rounding (e.g. 900,1 cents are 901 cents)
    Money.new(((self.price_cents - friendly_percent_result_cents) * fair_percentage).ceil)
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
    max = fair? ? Money.new(AUCTION_FEES[:max_fair]*100) : Money.new(AUCTION_FEES[:max_default]*100)
    r = max if r > max
    r
  end

end
