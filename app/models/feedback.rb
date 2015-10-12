#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class Feedback < ActiveRecord::Base
  extend Enumerize
  extend ActiveModel::Naming

  # Optional image
  has_one :image, class_name: 'FeedbackImage', foreign_key: 'imageable_id'
  accepts_nested_attributes_for :image

  enumerize :variety, in: [:report_article, :get_help, :send_feedback, :become_donation_partner]

  enumerize :feedback_subject, in: [:dealer, :technics, :other]
  # , :private, :buyer, :seller,:event, :cooperative, :hero, :ngo, :honor, :trust_community

  enumerize :help_subject, in: [:marketplace,  :technics, :cooperative,
                                :hero,  :other]
  #:comm_deal_fair, :comm_deal, :private_deal, :buy,:ngo, :honor, :trust_community

  # Validations
  validates :text, presence: true
  validates :variety, presence: true
  validates :from, presence: true, if: :needs_from?
  validates :feedback_subject, presence: true, if: proc { self.variety == 'send_feedback' }
  validates :help_subject, presence: true, if: proc { self.variety == 'get_help' }
  validates :subject, presence: true, if: :needs_subject?

  validates :from, format: { with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/ }, allow_blank: true
  validates :subject, length: { maximum: 254 }

  validates :recaptcha, presence: true, acceptance: true, on: :create, unless: :donation_partner_application?

  # validations for donation_partner
  validates :forename, presence: true, if: :donation_partner_application?
  validates :lastname, presence: true, if: :donation_partner_application?
  validates :organisation, presence: true, if: :donation_partner_application?
  validates :text, length: { minimum: 100 }, if: :donation_partner_application?

  # Relations
  belongs_to :user
  belongs_to :article

  # Manually set user ID so nobody tries to submit feedback under someone else's name
  # @api public
  # @param current_user [User, nil]
  # @return [undefined]
  def put_user_id current_user
    self.user_id = current_user.id if current_user
  end

  def translate_subject
    if self.variety == 'send_feedback'
      I18n.t("enumerize.feedback.feedback_subject.#{self.feedback_subject}")
    elsif self.variety == 'get_help'
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
