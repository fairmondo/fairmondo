module FastBillStubber
  def stub_fastbill
    Fastbill::Automatic::Customer.stubs( :create ).returns(Fastbill::Automatic::Customer.new(customer_id: 1))
    Fastbill::Automatic::Subscription.stubs(:create).returns(Fastbill::Automatic::Subscription.new(subscription_id: 1))
    Fastbill::Automatic::Subscription.stubs(:setusagedata)
    Fastbill::Automatic::Subscription.stubs(:get).returns([Fastbill::Automatic::Subscription.new(subscription_id: 1)])
    Fastbill::Automatic::Customer.stubs(:get).returns([Fastbill::Automatic::Customer.new(customer_id: 1)])
    Fastbill::Automatic::Customer.any_instance.stubs(:update_attributes)
    # FastbillAPI.stub( :fee_wo_vat ).with( instance_of(Article) )
    # FastbillAPI.stub( :fair_wo_vat ).with( instance_of(Article) )
  end
end
