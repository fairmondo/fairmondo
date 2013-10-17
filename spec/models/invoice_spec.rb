require 'spec_helper'

describe Invoice do
# 	let(:transaction) { FactoryGirl.create :single_transaction }
#   let(:article) { transaction.article }
#   let(:seller) { transaction.article.seller }
#   let(:user) { FactoryGirl.create :user }
#   let(:invoice) { FactoryGirl.create :invoice, :user_id => user.id }

  it "has a valid Factory" do
    FactoryGirl.build(:invoice).should be_valid
  end

  describe "model attributes" do
  	it { should respond_to :due_date }
  	it { should respond_to :state }
  	it { should respond_to :total_fee_cents }
    it { should respond_to :user_id }
  end

  describe "associations" do
  	it { should belong_to :user }
  	it { should have_many :transactions}
  end

  describe "validations" do
  	subject { FactoryGirl.create :invoice }
  	it { should validate_presence_of 'due_date' }
		it { should validate_presence_of 'state' }
		it { should validate_presence_of 'user_id' }
  end

  describe "state machine" do
		let ( :invoice ) { FactoryGirl.create :invoice }

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
  	let ( :invoice ) { FactoryGirl.create :invoice }
    let ( :user ) { FactoryGirl.create :user }

  	describe "that are public:" do
  		before do
  			article = FactoryGirl.create :article
  			transaction = article.transaction
  		end

  		# This is maybe not necessary
    #   it "'invoice_action_chain' should be triggered when 'transaction.buy' is executed" do
    #     pending
  		# end

      it "'calculate_total_fee' should calculate total_fee" do
        pending
      end

      describe "#add_quarterly_fee" do
        context 'invoice is last of this quarter' do
          it "should  add quarterly fee" do
            invoice.due_date = Time.now.at_end_of_quarter
            invoice.add_quarterly_fee
          end
        end

        context 'invoice is not last of this quarter' do
          it "should not add quarterly fee" do
            pending
          end
        end
      end

      describe '::create_new_invoice_and_add_item' do
        context "when user has an open invoice" do
          it "should not create a new invoice" do
            pending
          end
        end
        
        context 'when user has not an open invoice' do
          it "should create a new invoice" do
            pending
            # invoice.user_id = user.id
          end
        end
      end

      describe '#invoice_billable?' do
        context "invoice.total_fee_cents >= 1000" do
          it "should return true" do
            invoice.total_fee_cents = 1000
            invoice.invoice_billable?.should be_true
          end
        end

        context "invoice.total_fee_cents < 1000" do
          it "should return false" do
            invoice.total_fee_cents = 657
            invoice.invoice_billable?.should be_false
          end
        end
      end

      describe "#set_due_date" do
        context "invoice.total_fee_cents >= 1000" do
          it "due date should be at end of month" do
            invoice.total_fee_cents = 1001
            invoice.set_due_date
            invoice.due_date.should eq 30.days.from_now.at_end_of_month
          end
        end
        
        context "invoice.total_fee_cents < 1000" do
          it "due date should be at end of quarter" do
            invoice.total_fee_cents = 675
            invoice.set_due_date
            invoice.due_date.should eq 30.days.from_now.at_end_of_quarter
          end
        end
      end

      describe ""
        context "" do
          it '' do
            pending
          end
        end
        
        context "" do
          it '' do
            pending
          end
        end
      end
  	end
  end
