class DonationAbacus

  attr_reader :donations, :donation_total, :donation_per_organisation

  def self.calculate line_item_group
    abacus = DonationAbacus.new(line_item_group)
    abacus.calculate_donations
    abacus
  end

  def calculate_donations
    add_donation_organisations_to_donations @line_item_group.business_transactions.map{|t| t.article}
    @donations.each_value{ |v| @donation_total += v.sum }
    @donations.each_pair{ |k, v| @donation_per_organisation[k] = v.sum }
  end

  private

    def initialize line_item_group
      @line_item_group = line_item_group
      @donations = {}
      @donation_total = Money.new(0)
      @donation_per_organisation = {}
    end

    def add_donation_organisations_to_donations articles
      articles.each do |article|
        if article.friendly_percent_organisation_id && article.friendly_percent_organisation_id != 0
          organisation = User.find article.friendly_percent_organisation_id
          @donations[organisation] = [] unless @donations[organisation]
          @donations[organisation] << Money.new(article.calculated_friendly_cents)
        end
      end
    end
end
