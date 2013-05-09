class SocialProducerQuestionnaire < ActiveRecord::Base
  extend Enumerize

  attr_accessible :nonprofit_association, :nonprofit_association_purposes, :social_businesses_muhammad_yunus,  :social_businesses_muhammad_yunus_purposes, :social_entrepreneur, :social_entrepreneur_purposes

  belongs_to :auction

  def initialize(*args)
    if args.present?
      args[0].select{|k,v| k.match(/_purposes$/)}.each_pair do |k, v|
        args[0][k] = v.reject(&:empty?)
      end
    end
    super
  end

  validates_presence_of :nonprofit_association_purposes, :if => :nonprofit_association?

  serialize :nonprofit_association_purposes, Array
  enumerize :nonprofit_association_purposes, :in => [
    :youth_and_elderly,
    :art_and_culture,
    :national_and_vocational_training,
    :natural_protection,
    :charity,
    :persecuted_minorities_and_victims_of_persecution,
    :international_tolerance,
    :animal_protection,
    :development_cooperation,
    :consumer_protection,
    :convicts_and_ex_convicts,
    :sexual_equality,
    :democratic_political_system
  ], :multiple => true

  serialize :social_businesses_muhammad_yunus_purposes, Array
  validates_presence_of :social_businesses_muhammad_yunus_purposes, :if => :social_businesses_muhammad_yunus?
  enumerize :social_businesses_muhammad_yunus_purposes, :in =>  [
    :social_proplem,
    :dividend,
    :reinvestment,
    :natural_protection,
    :conditions_of_work
  ], :multiple => true

  serialize :social_entrepreneur_purposes, Array
  validates_presence_of :social_entrepreneur_purposes, :if => :social_entrepreneur?
  enumerize :social_entrepreneur_purposes, :in => [
    :social_proplem,
    :big_social_groups,
    :small_social_groups,
    :generally_charitable,
    :potential_social_advancement,
    :social_sensitization
  ], :multiple => true

end