# See http://rails-bestpractices.com/posts/19-use-observer
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#

class RefundObserver < ActiveRecord::Observer

  def after_create(refund)
    [ :fair, :fee ].each do | fee_type |
      FastbillRefundWorker.perform_async( refund.business_transaction.id, fee_type ) if refund.business_transaction.send("billed_for_#{fee_type.to_s}")
    end
    RefundMailer.delay.refund_notification(refund)
  end

end
