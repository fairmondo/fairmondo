require "spec_helper"
require "money-rails/test_helpers"

describe TransactionMailerHelper do
	before( :each ) do
		@transaction = FactoryGirl.create :transaction_with_buyer
	end

	describe "#transaction_mail_greeting( transaction, role )" do
		# pending "needs to be fixed"
		context "dependent on role it should return the right greeting" do
			it "if role is buyer it should return buyer greeting" do
				helper.transaction_mail_greeting( @transaction, :buyer ).should eq I18n.t('transaction.notifications.greeting') + @transaction.buyer_forename + ','
			end

			it "if role is seller it should return seller greeting" do
				helper.transaction_mail_greeting( @transaction, :seller ).should eq I18n.t('transaction.notifications.greeting') + @transaction.article_seller_forename + ','
			end
		end
	end

	describe "#fairnopoly_email_footer" do
		it "should return proper email footer" do
			helper.fairnopoly_email_footer.should have_content( I18n.t('common.fn_legal_footer.intro') )
			helper.fairnopoly_email_footer.should have_content( I18n.t('common.fn_legal_footer.footer_contact') )
			helper.fairnopoly_email_footer.should have_content( I18n.t('common.fn_legal_footer.registered') )
			helper.fairnopoly_email_footer.should have_content( I18n.t('common.fn_legal_footer.board') )
			helper.fairnopoly_email_footer.should have_content( I18n.t('common.fn_legal_footer.supervisory_board') )
			helper.fairnopoly_email_footer.should have_content( I18n.t('common.brand') )
			helper.fairnopoly_email_footer.should have_content( I18n.t('common.claim') )
			helper.fairnopoly_email_footer.should have_content( I18n.t('common.fn_legal_footer.facebook') )
			helper.fairnopoly_email_footer.should have_content( I18n.t('common.fn_legal_footer.buy_shares') )
		end
	end

	describe "#show_contact_info_seller( seller )" do
		it "should return the right address for the seller" do
			helper.show_contact_info_seller( @transaction.article_seller ).should have_content( @transaction.article_seller.forename )
			helper.show_contact_info_seller( @transaction.article_seller ).should have_content( @transaction.article_seller.surname )
			helper.show_contact_info_seller( @transaction.article_seller ).should have_content( @transaction.article_seller.street )
			helper.show_contact_info_seller( @transaction.article_seller ).should have_content( @transaction.article_seller.address_suffix )
			helper.show_contact_info_seller( @transaction.article_seller ).should have_content( @transaction.article_seller.city )
			helper.show_contact_info_seller( @transaction.article_seller ).should have_content( @transaction.article_seller.zip )
			helper.show_contact_info_seller( @transaction.article_seller ).should have_content( @transaction.article_seller.country )
		end
	end

	describe "#show_buyer_address( transaction )" do
		it "should return the right address for the buyer" do
			helper.show_buyer_address( @transaction ).should have_content( @transaction.forename )
			helper.show_buyer_address( @transaction ).should have_content( @transaction.surname )
			helper.show_buyer_address( @transaction ).should have_content( @transaction.address_suffix )
			helper.show_buyer_address( @transaction ).should have_content( @transaction.street )
			helper.show_buyer_address( @transaction ).should have_content( @transaction.city )
			helper.show_buyer_address( @transaction ).should have_content( @transaction.zip )
			helper.show_buyer_address( @transaction ).should have_content( @transaction.country )
		end
	end

	describe "#order_details( transaction )" do
		it "should return the right details for the order" do
			helper.order_details( @transaction ).should have_content( @transaction.article_title )
			helper.order_details( @transaction ).should have_content( article_path( @transaction.article ) )
			helper.order_details( @transaction ).should have_content( @transaction.article_title )
			helper.order_details( @transaction ).should have_content( @transaction.id)
		end
	end

	describe "#article_payment_info( transaction, role )" do
		it "should return the right details for article payment if user is the buyer" do
			pending "test not yet implemented"
			helper.article_payment_info( @transaction, :buyer ).should have_content( I18n.t('transaction.notifications.buyer.fair_percent') )
		end
	end

	describe "#payment_method_info( transaction )" do
		context "should return the string for the correct payment method" do
			it "for 'cash_on_delivery'" do
				@transaction.selected_payment = 'cash_on_delivery'

				helper.payment_method_info( @transaction, :buyer ).should have_content( I18n.t('transaction.notifications.buyer.cash_on_delivery') )
			end

			it "for 'bank_transfer'" do
				@transaction.selected_payment = 'bank_transfer'

				helper.payment_method_info( @transaction, :buyer ).should have_content( I18n.t('transaction.notifications.buyer.bank_transfer') )
       	helper.payment_method_info( @transaction, :buyer ).should have_content( I18n.t('transaction.notifications.buyer.please_pay') )
				helper.payment_method_info( @transaction, :buyer ).should_not have_content( @transaction.article_seller.bank_account_owner )
				helper.payment_method_info( @transaction, :buyer ).should_not have_content( @transaction.article_seller.bank_account_number )
				helper.payment_method_info( @transaction, :buyer ).should_not have_content( @transaction.article_seller.bank_code )
				helper.payment_method_info( @transaction, :buyer ).should_not have_content( @transaction.article_seller.bank_name )
			end

			it "for 'paypal'" do
				@transaction.selected_payment = 'paypal'

				helper.payment_method_info( @transaction, :buyer ).should eq I18n.t('transaction.notifications.buyer.paypal')
			end

			it "for 'invoice'" do
				@transaction.selected_payment = 'invoice'

				helper.payment_method_info( @transaction, :buyer ).should eq I18n.t('transaction.notifications.buyer.invoice')
			end

			it "for 'cash'" do
				@transaction.selected_payment = 'cash'

				helper.payment_method_info( @transaction, :buyer ).should eq I18n.t('transaction.notifications.buyer.cash')
			end
		end
	end

	# Diese Methode wird erstmal nicht mehr genutzt
	#
	# describe "#seller_bank_account( seller )" do
	# 	it "should return the right string for seller bank account" do
	# 		helper.seller_bank_account( @transaction.article_seller ).should have_content( @transaction.article_seller.bank_account_owner )
	# 		helper.seller_bank_account( @transaction.article_seller ).should have_content( @transaction.article_seller.bank_account_number )
	# 		helper.seller_bank_account( @transaction.article_seller ).should have_content( @transaction.article_seller.bank_code )
	# 		helper.seller_bank_account( @transaction.article_seller ).should have_content( @transaction.article_seller.bank_name )
	# 	end
	# end

	describe "#fees_and_donations( transaction )" do
		include MoneyRails::TestHelpers

		it "should return the right fees and donations string for the transaction" do
			pending "will be fixed when time comes"
			@transaction.article.calculate_fees_and_donations
			@transaction.quantity_bought = 2

			helper.fees_and_donations( @transaction ).should have_content( I18n.t('transaction.notifications.seller.fees') )
			helper.fees_and_donations( @transaction ).should have_content( "#{humanized_money_with_symbol( @transaction.article.calculated_fee * @transaction.quantity_bought )}" )

			helper.fees_and_donations( @transaction ).should have_content( I18n.t('transaction.notifications.seller.donations') )
			helper.fees_and_donations( @transaction ).should have_content( "#{humanized_money_with_symbol( @transaction.article.calculated_fair * @transaction.quantity_bought )}" )
		end
	end
end