class RefundMailer < ActionMailer::Base
  default from: $email_addresses['default']

  def refund_notification refund
    @refund = refund
    mail(to: 'storno@fairmondo.de',
         subject: '[Fairmondo] ' + 'Rueckerstattung: Transationsnummer: ' + "#{refund.business_transaction.id}") do |format|
          format.text
    end
  end
end
