require "spec_helper"
require "email_spec"

describe RefundMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  describe 'refund notification' do
    let( :refund ) { FactoryGirl.create :refund, reason: "not_in_stock" }
    let( :refund_notification ) { RefundMailer.refund_notification( refund ) }

    subject { refund_notification }

    it 'should be delivered to kundenservice@fairnopoly.de' do
      should deliver_to( 'kundenservice@fairnopoly.de' )
    end

    it 'should have right subject' do
      should have_subject('[Fairnopoly] Rueckerstattung: Transationsnummer: ' + "#{refund.transaction.id}" )
    end

    it 'should contain all data in body' do
      should have_body_text( refund.transaction.id.to_s )
      should have_body_text( refund.reason )
      should have_body_text( refund.description )
    end
  end
end
