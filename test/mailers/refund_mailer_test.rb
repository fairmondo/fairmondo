#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'
require 'email_spec'

class RefundMailerTest < ActiveSupport::TestCase
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  it '#refund_notification' do
    refund = create :refund, reason: 'not_in_stock'
    mail =  RefundMailer.refund_notification(refund)
    mail.must deliver_to('storno@fairmondo.de')
    mail.must have_subject('[Fairmondo] Rueckerstattung: Transationsnummer: ' + "#{refund.business_transaction.id}")
    mail.must have_body_text(refund.business_transaction.id.to_s)
    mail.must have_body_text(refund.reason)
    mail.must have_body_text(refund.description)
  end
end
