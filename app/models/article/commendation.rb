#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

module Article::Commendation
  extend ActiveSupport::Concern

  included do
    ##### commendation
    ## fair

    validates :fair_kind, presence: true, if: :fair?

    before_validation :delete_fair_kind_unless_fair

    enumerize :fair_kind, in: [:fair_seal, :fair_trust, :social_producer]

    validates :fair_seal, presence: true, if: lambda { |obj| obj.fair_kind == 'fair_seal' && obj.fair? }
    enumerize :fair_seal, in: [:trans_fair, :gots_fwf, :weltladen, :wtfo]

    ### fair trust questionnaire
    has_one :fair_trust_questionnaire, dependent: :destroy
    accepts_nested_attributes_for :fair_trust_questionnaire
    validates_associated :fair_trust_questionnaire, if: Proc.new { |obj| obj.fair_kind == 'fair_trust' && obj.fair? }

    before_validation :remove_fair_trust_questionnaire_unless_required

    ### social producer questionnaire
    has_one :social_producer_questionnaire, dependent: :destroy
    accepts_nested_attributes_for :social_producer_questionnaire
    validates_associated :social_producer_questionnaire, if: Proc.new { |obj| obj.fair_kind == 'social_producer' && obj.fair? }

    before_validation :remove_social_producer_questionnaire_unless_required

    ## ecologic

    validates :ecologic_kind, presence: true, if: :ecologic?
    validates :ecologic_seal, presence: true, if: lambda { |obj| obj.ecologic_kind == 'ecologic_seal' && obj.ecologic? }
    validates :upcycling_reason, presence: true, if: lambda { |obj| obj.ecologic_kind == 'upcycling'  && obj.ecologic? }
    validates :upcycling_reason, presence: true, length: { minimum: 150, maximum: 2500 }, if: lambda { |obj| obj.ecologic_kind == 'upcycling'  && obj.ecologic? }

    enumerize :ecologic_seal, in: [:bio_siegel, :eg_bio_siegel, :ecovin, :naturland, :gaea_e_v_oekologischer_landbau, :biokreis, :bioland, :biopark, :demeter, :europaeisches_umweltzeichen, :gots, :textiles_vertrauen_nach_oeko_tex_standard_100plus, :ivn_zertifiziert_naturtextil, :ivn_zertifiziert_naturtextil_best, :rainforest_alliance, :der_blaue_engel, :deutsches_gueteband_wein, :ecogarantie, :fsc_pure_papier, :fsc_pure_holz, :greenline, :gut, :kork_logo, :kompostierbar_compostable, :kontrollierte_natur_kosmetik_bdih, :natrue_natural_cosmetics_with_organic_portion, :natrue_organic_cosmetics, :natureplus, :oeko_control, :tco_certified, :utz_certified, :tuev_eco_kreis]
    enumerize :ecologic_kind, in: [:ecologic_seal, :upcycling]

    ## small_and_precious

    validates :small_and_precious_eu_small_enterprise, presence: true, if: :small_and_precious?
    validates :small_and_precious_reason, presence: true,
                                          length: { minimum: 150, maximum: 2500 },
                                          if: :small_and_precious?
    validates :small_and_precious_handmade, inclusion: { in: [true, false] }, if: :small_and_precious?
  end

  def has_commendation?
    self.fair || self.ecologic || self.small_and_precious
  end

  private

  def remove_fair_trust_questionnaire_unless_required
    self.fair_trust_questionnaire = nil unless self.fair_kind == 'fair_trust'
  end

  def remove_social_producer_questionnaire_unless_required
    self.social_producer_questionnaire = nil unless self.fair_kind == 'social_producer'
  end

  def delete_fair_kind_unless_fair
    self.fair_kind = nil unless fair?
  end
end
