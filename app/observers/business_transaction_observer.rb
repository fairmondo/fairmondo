#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class BusinessTransactionObserver < ActiveRecord::Observer
  def before_create record
    record.sold_at = Time.now

    if record.seller.is_a? LegalEntity
      record.line_item_group.buyer.increase_purchase_donations!(record)
    end
  end

  def before_save record
    if record.refunded_fair_changed? && record.refunded_fair &&
       record.seller.is_a?(LegalEntity)
      # decrease donation cache if refunded_fair changed from false to true
      record.buyer.decrease_purchase_donations!(record)
    end
  end
end
