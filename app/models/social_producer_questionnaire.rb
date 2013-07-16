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
class SocialProducerQuestionnaire < ActiveRecord::Base
  extend Enumerize

  attr_accessible :nonprofit_association, :nonprofit_association_purposes, :social_businesses_muhammad_yunus,  :social_businesses_muhammad_yunus_purposes, :social_entrepreneur, :social_entrepreneur_purposes

  belongs_to :article

  def initialize(*args)
    if args.present?
      args[0].select{|k,v| k.match(/_purposes$/)}.each_pair do |k, v|
        args[0][k] = v.reject(&:empty?)
      end
    end
    super
  end

  # Validations

  before_validation :is_social_producer?

  validates_presence_of :nonprofit_association_purposes, :if => :nonprofit_association?
  validates_presence_of :social_businesses_muhammad_yunus_purposes, :if => :social_businesses_muhammad_yunus?
  validates_presence_of :social_entrepreneur_purposes, :if => :social_entrepreneur?


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
  enumerize :social_businesses_muhammad_yunus_purposes, :in =>  [
    :social_proplem,
    :dividend,
    :reinvestment,
    :natural_protection,
    :conditions_of_work
  ], :multiple => true

  serialize :social_entrepreneur_purposes, Array
  enumerize :social_entrepreneur_purposes, :in => [
    :social_proplem,
    :big_social_groups,
    :small_social_groups,
    :generally_charitable,
    :potential_social_advancement,
    :social_sensitization
  ], :multiple => true


  def is_social_producer?
    self.nonprofit_association? || self.social_businesses_muhammad_yunus? || self.social_entrepreneur?
  end

end
