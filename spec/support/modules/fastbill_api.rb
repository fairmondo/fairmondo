module FastBillStubber
  def stub_fastbill
    Fastbill::Automatic::Customer.stub( :create ).and_return(Fastbill::Automatic::Customer.new(customer_id: 1))
    Fastbill::Automatic::Subscription.stub(:create).and_return(Fastbill::Automatic::Subscription.new(subscription_id: 1))
    Fastbill::Automatic::Subscription.stub(:setusagedata)
    Fastbill::Automatic::Subscription.stub(:get).and_return([Fastbill::Automatic::Subscription.new(subscription_id: 1)])
  end
end
