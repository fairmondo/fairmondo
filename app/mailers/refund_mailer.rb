class RefundMailer < ActionMailer::Base
  default from: $email_addresses['ArticleMailer']['default_from']

  def refund_notification refund
    @refund = refund
    mail( to: 'kundenservice@fairnopoly.de',
          subject: '[Fairnopoly] ' + 'Rueckerstattung: Transationsnummer: ' + "#{refund.transaction.id}" ) do |format|
          format.text
    end
  end
end
