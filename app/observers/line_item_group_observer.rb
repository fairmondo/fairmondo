class LineItemGroupObserver < ActiveRecord::Observer

  # sends email to courier service when line_item_group is payed and ready for transport
  def after_update(line_item_group)
    if (line_item_group.payment_state_changed? &&
        line_item_group.payment_completed?) &&
       (line_item_group.transport_state_changed? &&
        line_item_group.transport_ready?)
      CartMailer.delay.courier_notification(line_item_group)
    end
  end

end
