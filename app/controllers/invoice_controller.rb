class InvoiceController < InheritedResources::Base
	actions :create, :edit, :show

  private
    def invoice_params
      params.require(:user_id).permit(:due_date, :state, :total_fee_cents)
    end
end
