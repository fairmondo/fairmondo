# Monkey patch used Fastbill::Automatic functions to do nothing
module Fastbill
  module Automatic
    module Services
      module Create
        module ClassMethods
          def create *whatever
            self.name.constantize.new(:"#{self.name.split('::').last.downcase}_id" => 1)
          end
        end
      end
      module Update
        module ClassMethods
          def update_attributes *whatever
          end
        end
      end
      module Setusagedata
        module ClassMethods
          def setusagedata *whatever
          end
        end
      end
      module Get
        module ClassMethods
          def get *whatever
            [self.name.constantize.new(:"#{self.name.split('::').last.downcase}_id" => 1)]
          end
        end
      end
    end
  end
end

module FastBillStubber
  def stub_fastbill
    warn "[DEPRECATION] please remove FastBillStubber references. It's now stubbed out by default"
    # Fastbill::Automatic::Customer.stubs( :create ).returns(Fastbill::Automatic::Customer.new(customer_id: 1))
    # Fastbill::Automatic::Subscription.stubs(:create).returns(Fastbill::Automatic::Subscription.new(subscription_id: 1))
    # Fastbill::Automatic::Subscription.stubs(:setusagedata)
    # Fastbill::Automatic::Subscription.stubs(:get).returns([Fastbill::Automatic::Subscription.new(subscription_id: 1)])
    # Fastbill::Automatic::Customer.stubs(:get).returns([Fastbill::Automatic::Customer.new(customer_id: 1)])
    # Fastbill::Automatic::Customer.any_instance.stubs(:update_attributes)
    # # FastbillAPI.stub( :fee_wo_vat ).with( instance_of(Article) )
    # # FastbillAPI.stub( :fair_wo_vat ).with( instance_of(Article) )
  end
end

