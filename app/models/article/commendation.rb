#
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
module Article::Commendation
  extend ActiveSupport::Concern

  included do
    # def self.commendation_attrs
    #   [
    #     :fair, :ecologic, :fair_kind, :fair_seal, :ecologic_seal,
    #     :ecologic_kind, :upcycling_reason, :small_and_precious,
    #     :small_and_precious_eu_small_enterprise, :small_and_precious_reason,
    #     :small_and_precious_handmade,
    #     { fair_trust_questionnaire_attributes: FairTrustQuestionnaire.questionnaire_attrs },
    #     { social_producer_questionnaire_attributes: SocialProducerQuestionnaire.questionnaire_attrs }
    #   ]
    # end
    #! attr_accessible :fair, :ecologic , :fair_kind, :fair_seal, :ecologic_seal ,:ecologic_kind , :upcycling_reason , :small_and_precious, :small_and_precious_eu_small_enterprise, :small_and_precious_reason, :small_and_precious_handmade
    #! attr_accessible :fair_trust_questionnaire_attributes, :social_producer_questionnaire_attributes


    ##### commendation
    ## fair

    validates_presence_of :fair_kind, :if => :fair?

    before_validation :delete_fair_kind_unless_fair

    enumerize :fair_kind, :in => [:fair_seal, :fair_trust, :social_producer]

    validates_presence_of :fair_seal, :if => lambda {|obj| obj.fair_kind == "fair_seal" && obj.fair?}
    enumerize :fair_seal, :in => [:trans_fair, :gots_fwf, :weltladen, :wtfo]

    ### fair trust questionnaire
    has_one :fair_trust_questionnaire, :dependent => :destroy
    accepts_nested_attributes_for :fair_trust_questionnaire
    validates_associated :fair_trust_questionnaire, :if =>  Proc.new {|obj| obj.fair_kind == "fair_trust" && obj.fair?}

    before_validation :remove_fair_trust_questionnaire_unless_required

    ### social producer questionnaire
    has_one :social_producer_questionnaire, :dependent => :destroy
    accepts_nested_attributes_for :social_producer_questionnaire
    validates_associated :social_producer_questionnaire, :if =>  Proc.new {|obj| obj.fair_kind == "social_producer" && obj.fair?}

    before_validation :remove_social_producer_questionnaire_unless_required

    ## ecologic

    validates_presence_of :ecologic_kind, :if => :ecologic?
    validates_presence_of :ecologic_seal, :if => lambda {|obj| obj.ecologic_kind == "ecologic_seal" && obj.ecologic?}
    validates_presence_of :upcycling_reason, :if => lambda {|obj| obj.ecologic_kind == "upcycling"  && obj.ecologic?}
    validates :upcycling_reason, :length => { :minimum => 150, :maximum => 2500 }, :if => lambda {|obj| obj.ecologic_kind == "upcycling"  && obj.ecologic?}

    enumerize :ecologic_seal, :in => [:bio_siegel, :eg_bio_siegel, :ecovin, :naturland, :gaea_e_v_oekologischer_landbau, :biokreis, :bioland, :biopark, :demeter, :europaeisches_umweltzeichen, :gots, :textiles_vertrauen_nach_oeko_tex_standard_100plus, :ivn_zertifiziert_naturtextil, :ivn_zertifiziert_naturtextil_best, :rainforest_alliance, :der_blaue_engel, :deutsches_gueteband_wein, :ecogarantie, :fsc_pure_papier, :fsc_pure_holz, :greenline, :gut, :kork_logo, :kompostierbar_compostable, :kontrollierte_natur_kosmetik_bdih, :natrue_natural_cosmetics_with_organic_portion, :natrue_organic_cosmetics, :natureplus, :oeko_control, :tco_certified, :utz_certified, :tuev_eco_kreis]
    enumerize :ecologic_kind, :in => [:ecologic_seal , :upcycling]

    ## small_and_precious

    validates_presence_of :small_and_precious_eu_small_enterprise, :if => :small_and_precious?
    validates_presence_of :small_and_precious_reason, :if => :small_and_precious?
    validates :small_and_precious_reason, :length => { :minimum => 150, :maximum => 2500 }, :if => :small_and_precious?
    #validates_presence_of :small_and_precious_handmade, :if => :small_and_precious?  # this allows only value true, but not false
    validates_inclusion_of :small_and_precious_handmade, :in => [true, false], :if => :small_and_precious?
  end

  def has_commendation?
     self.fair || self.ecologic || self.small_and_precious
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
