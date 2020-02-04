#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class FeedbackMailerTest < ActiveSupport::TestCase
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  it '#feedback_and_help' do
    mail = FeedbackMailer.feedback_and_help Feedback.new(text: 'foobar', variety: 'send_feedback', subject: 'bazfuz'), 'dealer'
    mail.must deliver_to EMAIL_ADDRESSES['FeedbackMailer']['send_feedback']['dealer']
    mail.must deliver_from EMAIL_ADDRESSES['default']
    mail.must have_subject 'bazfuz'
  end

  it '#donation_partner' do
    mail = FeedbackMailer.donation_partner Feedback.new(text: 'foobar', variety: 'become_donation_partner', subject: 'Spendenpartner*in Anfrage', from: EMAIL_ADDRESSES['default'])

    mail.must deliver_to EMAIL_ADDRESSES['FeedbackMailer']['become_donation_partner']
    mail.must deliver_from EMAIL_ADDRESSES['default']
    mail.must have_subject 'Spendenpartner*in Anfrage'
  end
end
