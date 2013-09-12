require "spec_helper"

describe TransactionMailerHelper do
	let (:transaction) { FactoryGirl.create :transaction_with_buyer }

	describe "transaction_mail_greeting( transaction, role )" do
		pending "needs to be fixed"
		context "dependent on role it should return the right greeting" do
			it "if role is buyer it should return buyer greeting" do
				helper.transaction_mail_greeting( transaction, :buyer ).should eq I18n.t('transaction.notifications.greeting') + ' ' + transaction.buyer_forename + ','
			end

			it "if role is seller it should return seller greeting" do
				helper.transaction_mail_greeting( transaction, :seller ).should eq I18n.t('transaction.notifications.greeting') + ' ' + transaction.article_seller_forename + ','
			end
		end
	end

	describe "fairnopoly_email_footer" do
		it "should return proper email footer" do
		end
	end

	describe "show_contact_info_seller( seller )" do
		it "should return the right address for the seller" do
		end
	end

	describe "show_buyer_address( transaction )" do
		it "should return the right address for the buyer" do
		end
	end

	describe "order_details( transaction )" do
		it "should return the right details for the order" do
		end
	end

	describe "article_payment_info( transaction, role )" do
		it "should return the right details for article payment" do
		end
	end

	describe "payment_method_info( transaction )" do
		context "should return the string for the correct payment method" do
			it "for 'cash_on_delivery'" do
				transaction.selected_payment = 'cash_on_delivery'

				helper.payment_method_info( transaction ).should eq I18n.t('transaction.notifications.buyer.cash_on_delivery')
			end

			it "for 'bank_transfer'" do
				transaction.selected_payment = 'bank_transfer'

				helper.payment_method_info( transaction ).should eq "#{ I18n.t('transaction.notifications.buyer.bank_transfer') }\n" +
        	"#{ I18n.t('transaction.notifications.buyer.please_pay') }\n" +
        	"#{ seller_bank_account transaction.article_seller }"
			end

			it "for 'paypal'" do
				transaction.selected_payment = 'paypal'

				helper.payment_method_info( transaction ).should eq I18n.t('transaction.notifications.buyer.paypal')
			end

			it "for 'invoice'" do
				transaction.selected_payment = 'invoice'

				helper.payment_method_info( transaction ).should eq I18n.t('transaction.notifications.buyer.invoice')
			end

			it "for 'cash'" do
				transaction.selected_payment = 'cash'

				helper.payment_method_info( transaction ).should eq I18n.t('transaction.notifications.buyer.cash')
			end
		end
	end

	describe "seller_bank_account( seller )" do
		it "should return the right string for seller bank account" do
		end
	end

	describe "fees_and_donations( transaction )" do
		it "should return the right fees and donations string for the transaction" do
		end
	end
end