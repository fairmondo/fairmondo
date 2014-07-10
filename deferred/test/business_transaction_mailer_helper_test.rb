require "test_helper"


describe BusinessTransactionMailerHelper do

  before( :each ) do
    @business_transaction = FactoryGirl.create :business_transaction_with_buyer
    buyer                 = @business_transaction.buyer
    @business_transaction.transport_address = buyer.standard_address
    @business_transaction.payment_address  = buyer.standard_address
  end

  describe "#transaction_mail_greeting( transaction, role )" do
    context "dependent on role it should return the right greeting" do
      it "if role is buyer it should return buyer greeting" do
        helper.transaction_mail_greeting( @business_transaction, :buyer ).must_equal I18n.t('transaction.notifications.greeting') + @business_transaction.buyer.standard_address_first_name + ','
      end

      it "if role is seller it should return seller greeting" do
        helper.transaction_mail_greeting( @business_transaction, :seller ).must_equal I18n.t('transaction.notifications.greeting') + @business_transaction.article_seller.standard_address_first_name + ','
      end
    end
  end


  describe "#contact_info_for( seller )" do
    it "should return the right address for the seller" do
      [FactoryGirl.create(:private_user), FactoryGirl.create(:legal_entity), FactoryGirl.create(:legal_entity_without_company_name)].each do |user|
        contact_info = helper.contact_info_for( user )
        if user.class == 'LegalEntity'
          contact_info.must_include( user.nickname )
          contact_info.must_include( user.company_name )
        end
        contact_info.must_include( user.standard_address.first_name )
        contact_info.must_include( user.standard_address.last_name )
        contact_info.must_include( user.standard_address.address_line_1 )
        contact_info.must_include( user.standard_address.address_line_2 )
        contact_info.must_include( user.standard_address.city )
        contact_info.must_include( user.standard_address.zip )
        contact_info.must_include( user.standard_address.country )
      end
    end
  end

  describe "#show_buyer_address( business_transaction )" do
    it "should return the right transport_address for the buyer" do
      address = helper.show_buyer_address( @business_transaction.transport_address )
      address.must_contain( @business_transaction.transport_address.title )
      address.must_contain( @business_transaction.transport_address.first_name )
      address.must_contain( @business_transaction.transport_address.last_name )
      address.must_contain( @business_transaction.transport_address.address_line_1 )
      address.must_contain( @business_transaction.transport_address.address_line_2 )
      address.must_contain( @business_transaction.transport_address.city )
      address.must_contain( @business_transaction.transport_address.zip )
      address.must_contain( @business_transaction.transport_address.country )
    end
  end

  describe "#show_buyer_address( business_transaction )" do
    it "should return the right payment_address for the buyer" do
      address = helper.show_buyer_address( @business_transaction.payment_address )
      address.must_contain( @business_transaction.payment_address.title )
      address.must_contain( @business_transaction.payment_address.first_name )
      address.must_contain( @business_transaction.payment_address.last_name )
      address.must_contain( @business_transaction.payment_address.address_line_1 )
      address.must_contain( @business_transaction.payment_address.address_line_2 )
      address.must_contain( @business_transaction.payment_address.city )
      address.must_contain( @business_transaction.payment_address.zip )
      address.must_contain( @business_transaction.payment_address.country )
    end
  end

  describe "#order_details( transaction )" do
    it "should return the right details for the order" do
      details = helper.order_details( @business_transaction )
      details.must_contain( @business_transaction.article_title )
      details.must_contain( article_path( @business_transaction.article ) )
      details.must_contain( @business_transaction.article_title )
      details.must_contain( @business_transaction.id)
    end
    it "should return a transport type 1 provider if it is set" do

      @business_transaction = FactoryGirl.create :business_transaction_with_buyer, :transport_type_1_selected
      helper.order_details( @business_transaction ).must_include( @business_transaction.article.transport_type1_provider )
    end
    it "should return a transport type 2 provider if it is set" do
      @business_transaction = FactoryGirl.create :business_transaction_with_buyer, :transport_type_2_selected
      helper.order_details( @business_transaction ).must_include( @business_transaction.article.transport_type2_provider )
    end
    it "should return a custom_seller_identifier if it is set" do
      @business_transaction = FactoryGirl.create :business_transaction_with_buyer, :article => FactoryGirl.create(:article, :with_custom_seller_identifier)
      helper.order_details( @business_transaction ).must_include( @business_transaction.article.custom_seller_identifier )
    end

  end

  describe "#article_payment_info( transaction, role )" do
    it "should return the right details for article payment if user is the buyer" do
      helper.article_payment_info( @business_transaction, :buyer ).must_include( I18n.t('transaction.notifications.buyer.fair_percent') )
    end
    it "should return the right details for article payment if user is the buyer and cash on delivery is selected" do
      @business_transaction = FactoryGirl.create :business_transaction_with_friendly_percent_and_buyer, :cash_on_delivery_selected
      helper.article_payment_info( @business_transaction, :buyer ).must_include( I18n.t('transaction.edit.cash_on_delivery') )
    end
  end

  describe "#payment_method_info( transaction )" do
    context "should return the string for the correct payment method" do
      it "for 'cash_on_delivery'" do
        @business_transaction.selected_payment = 'cash_on_delivery'

        helper.payment_method_info( @business_transaction, :buyer ).must_include( I18n.t('transaction.notifications.buyer.cash_on_delivery') )
      end

      it "for 'bank_transfer'" do
        @business_transaction.selected_payment = 'bank_transfer'
        payment_method = helper.payment_method_info( @business_transaction, :buyer )
        payment_method.must_include( I18n.t('transaction.notifications.buyer.bank_transfer') )
        payment_method.must_include( I18n.t('transaction.notifications.buyer.please_pay') )
        payment_method.wont_include( @business_transaction.article_seller.bank_account_owner )
        payment_method.wont_include( @business_transaction.article_seller.bank_account_number )
        payment_method.wont_include( @business_transaction.article_seller.bank_code )
        payment_method.wont_include( @business_transaction.article_seller.bank_name )
      end

      it "for 'paypal'" do
        @business_transaction.selected_payment = 'paypal'

        helper.payment_method_info( @business_transaction, :buyer ).must_equal I18n.t('transaction.notifications.buyer.paypal')
      end

      it "for 'invoice'" do
        @business_transaction.selected_payment = 'invoice'

        helper.payment_method_info( @business_transaction, :buyer ).must_equal I18n.t('transaction.notifications.buyer.invoice')
      end

      it "for 'cash'" do
        @business_transaction.selected_payment = 'cash'

        helper.payment_method_info( @business_transaction, :buyer ).must_equal I18n.t('transaction.notifications.buyer.cash')
      end
    end
  end

  # describe "#fees_and_donations( business_transaction )" do

  #   it "should return the right fees and donations string for the business_transaction" do
  #     skip "will be fixed when time comes"
  #     @business_transaction.article.calculate_fees_and_donations
  #     @business_transaction.quantity_bought = 2

  #     fees_and_donations = helper.fees_and_donations( @business_transaction )
  #     fees_and_donations.must_include( I18n.t('transaction.notifications.seller.fees') )
  #     fees_and_donations.must_include( "#{humanized_money_with_symbol( @business_transaction.article.calculated_fee * @business_transaction.quantity_bought )}" )

  #     fees_and_donations.must_include( I18n.t('transaction.notifications.seller.donations') )
  #     fees_and_donations.must_include( "#{humanized_money_with_symbol( @business_transaction.article.calculated_fair * @business_transaction.quantity_bought )}" )
  #   end
  # end
end
