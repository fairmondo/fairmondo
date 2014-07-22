require_relative '../test_helper'
require "email_spec"

describe RefundMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  include FastBillStubber

  it '#refund_notification' do
    refund = FactoryGirl.create :refund, reason: "not_in_stock"
    mail =  RefundMailer.refund_notification( refund )
    mail.must deliver_to( 'storno@fairnopoly.de' )
    mail.must have_subject('[Fairnopoly] Rueckerstattung: Transationsnummer: ' + "#{refund.business_transaction.id}" )
    mail.must have_body_text( refund.business_transaction.id.to_s )
    mail.must have_body_text( refund.reason )
    mail.must have_body_text( refund.description )
  end
end
