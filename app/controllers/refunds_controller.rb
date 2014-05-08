class RefundsController < InheritedResources::Base
  respond_to :html
  actions :create, :new
  before_filter :authorize_with_business_transaction, only: [ :new, :create ]

  def create
    create! do | success, failure |
      success.html { return redirect_to user_path( current_user ), notice: t( 'refund.notice' ) }
    end
  end

  private
    def authorize_with_business_transaction
      refund = build_resource
      refund.business_transaction = BusinessTransaction.find( params[ :business_transaction_id ] )
      authorize refund
    end
end
