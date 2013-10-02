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

  def self.feedback_attrs
    [:from, :subject, :text, :variety, :article_id, :feedback_subject,
    :help_subject]
  end
  #! attr_accessible ...

  enumerize :variety, in: [ :report_article, :get_help, :send_feedback ]

  enumerize :feedback_subject, in: [ :dealer, :technics, :other]
                                     #, :private, :buyer, :seller,:event, :cooperative, :hero, :ngo, :honor, :trust_community

  enumerize :help_subject, in: [ :marketplace,  :technics, :cooperative,
                                 :hero,  :other ]
                                  #:comm_deal_fair, :comm_deal, :private_deal, :buy,:ngo, :honor, :trust_community

  # Validations
  validates :text, presence: true

  validates :variety, presence: true

  validates :from, format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/ },
                   allow_blank: true
  validates :feedback_subject, presence: true, if: lambda { self.variety == 'send_feedback' }
  validates :help_subject, presence: true, if: lambda { self.variety == 'get_help' }
  validates :subject, presence: true, unless: :is_report_article
  validates :subject, length: { maximum: 254 }
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
    def is_report_article
      self.variety == 'report_article'
    end
end
