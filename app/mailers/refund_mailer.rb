#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class RefundMailer < ActionMailer::Base
  default from: EMAIL_ADDRESSES['default']

  def refund_notification refund
    @refund = refund
    mail(to: 'storno@fairmondo.de',
         subject: '[Fairmondo] ' + 'Rueckerstattung: Transationsnummer: ' + "#{refund.business_transaction.id}") do |format|
      format.text
    end
  end
end
