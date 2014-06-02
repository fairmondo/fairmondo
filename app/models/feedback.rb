#
# Fairnopoly - Fairnopoly is an open-source online marketplace.
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
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
class Feedback < ActiveRecord::Base
  extend Enumerize
  extend ActiveModel::Naming

  # Optional image
  has_one :image, :class_name => "FeedbackImage", foreign_key: "imageable_id"
  accepts_nested_attributes_for :image

  enumerize :variety, in: [ :report_article, :get_help, :send_feedback, :become_donation_partner ]

  enumerize :feedback_subject, in: [ :dealer, :technics, :other]
                                     #, :private, :buyer, :seller,:event, :cooperative, :hero, :ngo, :honor, :trust_community

  enumerize :help_subject, in: [ :marketplace,  :technics, :cooperative,
                                 :hero,  :other ]
                                  #:comm_deal_fair, :comm_deal, :private_deal, :buy,:ngo, :honor, :trust_community

  # Validations
  validates_presence_of :text
  validates_presence_of :variety
  validates_presence_of :from, if: :needs_from?
  validates_presence_of :feedback_subject, if: proc { self.variety == 'send_feedback' }
  validates_presence_of :help_subject, if: proc { self.variety == 'get_help' }
  validates_presence_of :subject, if: :needs_subject?

  validates :from, format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/ }, allow_blank: true
  validates :subject, length: { maximum: 254 }

  validates :recaptcha, presence: true, acceptance: true, on: :create, unless: :donation_partner_application?

  # validations for donation_partner
  validates_presence_of :forename, if: :donation_partner_application?
  validates_presence_of :lastname, if: :donation_partner_application?
  validates_presence_of :organisation , if: :donation_partner_application?
  validates :text, length: { minimum: 100 }, if: :donation_partner_application?

  #Relations
  belongs_to :user
  belongs_to :article

  # Manually set user ID so nobody tries to submit feedback under someone else's name
  # @api public
  # @param current_user [User, nil]
  # @return [undefined]
  def set_user_id current_user
    self.user_id = current_user.id if current_user
  end

  def translate_subject
    if self.variety == "send_feedback"
      I18n.t("enumerize.feedback.feedback_subject.#{self.feedback_subject}")
    elsif self.variety == "get_help"
      I18n.t("enumerize.feedback.help_subject.#{self.help_subject}")
    end
  end

  def last_article_id
    if self.user_id && User.find(self.user_id).articles.last
      User.find(self.user_id).articles.last.id
    elsif self.user_id
      I18n.t('feedback.details.no_article_existent')
    else
      I18n.t('feedback.details.user_not_logged_in')
    end
  end

  private
    # For validation
    # @api private

    def needs_subject?
      self.variety == 'send_feedback' ||
      self.variety == 'get_help'
    end
    def needs_from?
      self.variety == 'become_donation_partner' ||
      self.variety == 'get_help'
    end
    def donation_partner_application?
      self.variety == 'become_donation_partner'
    end
end
