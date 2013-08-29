require 'spec_helper'

describe Invoice do
# 	let(:transaction) { FactoryGirl.create :single_transaction }
#   let(:article) { transaction.article }
#   let(:seller) { transaction.article.seller }
#   let(:user) { FactoryGirl.create :user }
#   let(:invoice) { FactoryGirl.create :invoice, :user_id => user.id }
# end

  describe "model attributes" do
  	it { should respond_to :due_date }
  	it { should respond_to :state }
  	it { should respond_to :user_id }
  	it { should respond_to :total_fee_cents }
  end

  describe "associations" do
  	it { should belong_to :user }
  	it { should have_many :invoice_items }
  	it { should have_many :articles }
  end

  describe "validations" do
  	subject { FactoryGirl.create :invoice }
  	it { should validate_presence_of 'due_date' }
		it { should validate_presence_of 'state' }
		it { should validate_presence_of 'user_id' }
		it { should validate_presence_of 'total_fee_cents' }
		it { should validate_numericality_of 'total_fee_cents'}
  end

  describe "state machine" do
		let (:invoice) { FactoryGirl.create :invoice }

  	describe "states" do
  		it "should have state 'open'" do
  			invoice.should respond_to :open?
  		end

  		it "should have state 'first_reminder'" do
  			invoice.should respond_to :first_reminder?
  		end

  		it "should have state 'second_reminder'" do
  			invoice.should respond_to :second_reminder?
  		end

  		it "should have state 'closed'" do
  			invoice.should respond_to :closed?
  		end
  	end

	  describe "event" do
	  	it "close should set state from 'open' to 'closed'" do
	  		invoice.close
	  		invoice.state.should eq 'closed'
	  	end

	  	it "close should set state from 'first_reminder' to 'closed'" do
	  		invoice.state = "first_reminder"
	  		invoice.close
	  		invoice.state.should eq 'closed'
	  	end

	  	it "close should set state from 'second_reminder' to 'closed'" do
	  		invoice.state = "second_reminder"
	  		invoice.close
	  		invoice.state.should eq 'closed'
	  	end

	  	it "remind should set state from 'open' to 'first_reminder'" do
	  		invoice.state = "open"
	  		invoice.remind
	  		invoice.state.should eq 'first_reminder'
	  	end

	  	it "remind should set state from 'first_reminder' to 'second_reminder'" do
	  		invoice.state = "first_reminder"
	  		invoice.remind
	  		invoice.state.should eq 'second_reminder'
	  	end
	  end
	end

  describe "methods" do
  	let (:invoice) { FactoryGirl.create :invoice }

  	describe "that are public:" do
  		before do
  			article = FactoryGirl.create :article
  			transaction = article.transaction
  		end

  		it "'invoice_action_chain' should be triggered when 'transaction.buy' is executed" do
        pending
  		end

      it "'calculate_total_fee' should calculate total_fee" do
        pending
      end

      it "'add_quarterly_fee' should add the quarterly fee to invoice" do
        pending
      end

      context "is the invoice billable? dependent on 'total_fee_cents" do
        it "'invoice_billable?' should  return 'true' if total_fee_cents is 1000 or bigger" do
          invoice.total_fee_cents = 1000
          invoice.invoice_billable?.should be_true
        end

        it "'invoice_billable?' should  return 'false' if total_fee_cents is between 0 and 999" do
          invoice.total_fee_cents = 657
          invoice.invoice_billable?.should be_false
        end
      end

      context "set due date dependent on invoice_billable?" do
        it "due date should be at end of month if invoice is billable" do
          invoice.total_fee_cents = 1001
          invoice.set_due_date
          invoice.due_date.should eq 30.days.from_now.at_end_of_month
        end

        it "due date should be at end of quarter if invoice is not billable" do
          invoice.total_fee_cents = 675
          invoice.set_due_date
          invoice.due_date.should eq 30.days.from_now.at_end_of_quarter
        end
      end
  	end
  end
end




