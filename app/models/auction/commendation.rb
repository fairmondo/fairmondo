module Auction::Commendation
  extend ActiveSupport::Concern

  included do
    
    attr_accessible :fair, :ecologic , :fair_kind, :fair_seal, :ecologic_seal , :small_and_precious, :small_and_precious_edition , :small_and_precious_eu_small_enterprise, :small_and_precious_reason, :small_and_precious_handmade
    attr_accessible :fair_trust_questionnaire_attributes, :social_producer_questionnaire_attributes
    
    scope :with_commendation, lambda { |*commendations|
      return scoped unless commendations.present?
      auction_table = self.arel_table
      arel_condition = nil
      commendations.each do |commendation|
        if arel_condition
          arel_condition = arel_condition.or(auction_table[commendation].eq(true))
        else
          arel_condition = auction_table[commendation].eq(true)
        end
      end
      where(arel_condition)
    }  
      
      
    ##### commendation
    ## fair
    
    validates_presence_of :fair_kind, :if => :fair?
    
    before_validation :delete_fair_kind_unless_fair
    
    enumerize :fair_kind, :in => [:fair_seal, :fair_trust, :social_producer]
    
    validates_presence_of :fair_seal, :if => lambda {|obj| obj.fair_kind == "fair_seal"}
    enumerize :fair_seal, :in => [:trans_fair, :weltladen, :wtfo], :default => :trans_fair
    
    ### fair trust questionnaire
    has_one :fair_trust_questionnaire, :dependent => :destroy
    accepts_nested_attributes_for :fair_trust_questionnaire
    validates_associated :fair_trust_questionnaire, :if => lambda {|obj| obj.fair_kind == "fair_trust"}
    
    before_validation :remove_fair_trust_questionnaire_unless_required
  
    ### social producer questionnaire
    has_one :social_producer_questionnaire, :dependent => :destroy
    accepts_nested_attributes_for :social_producer_questionnaire
    validates_associated :social_producer_questionnaire, :if => lambda {|obj| obj.fair_kind == "social_producer"}
    
    before_validation :remove_social_producer_questionnaire_unless_required
  
    ## ecologic
    
    validates_presence_of :ecologic_seal, :if => :ecologic?
    enumerize :ecologic_seal, :in => [:bio_siegel, :eg_bio_siegel, :ecovin, :naturland, :gaea_e_v_oekologischer_landbau, :biokreis, :bioland, :biopark, :demeter, :europaeisches_umweltzeichen, :gots, :textiles_vertrauen_nach_oeko_tex_standard_100plus, :ivn_zertifiziert_naturtextil, :ivn_zertifiziert_naturtextil_best, :rainforest_alliance, :der_blaue_engel, :deutsches_gueteband_wein, :ecogarantie, :fsc_pure_papier, :fsc_pure_holz, :greenline, :gut, :kork_logo, :kompostierbar_compostable, :kontrollierte_natur_kosmetik_bdih, :natrue_natural_cosmetics_with_organic_portion, :natrue_organic_cosmetics, :natureplus, :oeko_control, :tco_certified, :utz_certified, :tuev_eco_kreis]
    
    ## small_and_precious
    
    validates_presence_of :small_and_precious_eu_small_enterprise, :if => :small_and_precious?
    validates_presence_of :small_and_precious_edition, :if => :small_and_precious?
    validates_numericality_of :small_and_precious_edition, :greater_than => 0, :if => :small_and_precious?
    validates_presence_of :small_and_precious_reason, :if => :small_and_precious?
    validates_length_of :small_and_precious_reason, :minimum => 200, :if => :small_and_precious?
  end
  
  private
  
  def remove_fair_trust_questionnaire_unless_required
    self.fair_trust_questionnaire = nil unless self.fair_kind == "fair_trust"
  end
  
  def remove_social_producer_questionnaire_unless_required
    self.social_producer_questionnaire = nil unless self.fair_kind == "social_producer"
  end
  
  def delete_fair_kind_unless_fair
    self.fair_kind = nil unless fair?
  end
  
end