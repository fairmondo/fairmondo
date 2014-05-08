class FastbillAPI
  require 'fastbill-automatic'

  #Here be FastBill stuff
  #
  # The fastbill_chain takes control of all the necessary steps to handle
  # fastbill customer creation and adding business_transactions fees to a user's
  # fastbill account
  def self.fastbill_chain business_transaction
    seller = business_transaction.seller
    seller.with_lock do
      unless seller.ngo?
        unless seller.has_fastbill_profile?
          fastbill_create_customer seller
          fastbill_create_subscription seller
        end

        [ :fair, :fee ].each do | type |
          fastbill_setusagedata seller, business_transaction, type
        end

        fastbill_discount seller, business_transaction if business_transaction.discount
      end
    end
  end


  private

    def self.fastbill_create_customer seller
      unless seller.fastbill_id
        User.observers.disable :user_observer do
          attributes = attributes_for(seller)
          attributes[:customer_number] = seller.id
          customer = Fastbill::Automatic::Customer.create(attributes)
          seller.fastbill_id = customer.customer_id
          seller.save
        end
      end
    end


    def self.update_profile user
      customer = Fastbill::Automatic::Customer.get( customer_id: user.fastbill_id ).first
      if customer
        attributes = attributes_for user
        attributes[:customer_id] = user.fastbill_id
        customer.update_attributes( attributes )
      end
    end


    def self.attributes_for user
      {
        customer_type: user.is_a?(LegalEntity) ? 'business' : 'consumer',
        organization: (user.company_name? && user.is_a?(LegalEntity)) ? user.company_name : user.nickname,
        salutation: user.title,
        first_name: user.forename,
        last_name: user.surname,
        address: user.street,
        address_2: user.address_suffix,
        zipcode: user.zip,
        city: user.city,
        country_code: 'DE',
        language_code: 'DE',
        email: user.email,
        currency_code: 'EUR',
        payment_type: '1', # Ueberweisung
        # payment_type: '2', # Bankeinzug # Bitte aktivieren, wenn Genehmigung der Bank vorliegt
        show_payment_notice: '1',
        bank_name: user.bank_name,
        bank_code: user.bank_code,
        bank_account_number: user.bank_account_number,
        bank_account_owner: user.bank_account_owner
      }
    end


    def self.fastbill_create_subscription seller
      unless seller.fastbill_subscription_id
        User.observers.disable :user_observer do
          subscription = Fastbill::Automatic::Subscription.create( article_number: '10',
                                                    customer_id: seller.fastbill_id,
                                                    next_event: Time.now.end_of_month.strftime("%Y-%m-%d %H:%M:%S")
                                                  )
          seller.fastbill_subscription_id = subscription.subscription_id
          seller.save
        end
      end
    end

    # This method adds articles and their according fee type to the invoice
    def self.fastbill_setusagedata seller, business_transaction, fee_type
      unless (fee_type == :fair && business_transaction.billed_for_fair) || (fee_type == :fee && business_transaction.billed_for_fee)
        article = business_transaction.article

        Fastbill::Automatic::Subscription.setusagedata( subscription_id: seller.fastbill_subscription_id,
                                                        article_number: fee_type == :fair ? '11' : '12',
                                                        quantity: business_transaction.quantity_bought,
                                                        unit_price: fee_type == :fair ? ( fair_wo_vat article ) : ( fee_wo_vat article ),
                                                        description: business_transaction.id.to_s + "  " + article.title + " (#{ fee_type == :fair ? I18n.t( 'invoice.fair' ) : I18n.t( 'invoice.fee' )})",
                                                        usage_date: business_transaction.sold_at.strftime("%Y-%m-%d %H:%M:%S")
                                                      )
        business_transaction.update_attribute("billed_for_#{fee_type}".to_sym, true)
      end
    end

    # This method adds an discount (if discount is given for business_transaction)
    def self.fastbill_discount seller, business_transaction
      unless business_transaction.billed_for_discount
        article = business_transaction.article

        Fastbill::Automatic::Subscription.setusagedata( subscription_id: seller.fastbill_subscription_id,
                                                        article_number: '12',
                                                        unit_price: -( discount_wo_vat business_transaction ),
                                                        description: business_transaction.id.to_s + "  " + article.title + " (" + business_transaction.discount_title + ")",
                                                        usage_date: business_transaction.sold_at.strftime("%Y-%m-%d %H:%M:%S")
                                                      )
        business_transaction.update_attribute(:billed_for_discount, true)
      end
    end

    # This method adds an refund to the invoice is refund is requested for an article
    def self.fastbill_refund business_transaction, fee_type
      article = business_transaction.article
      seller = business_transaction.seller

      Fastbill::Automatic::Subscription.setusagedata( subscription_id: seller.fastbill_subscription_id,
                                                      article_number: fee_type == :fair ? '11' : '12',
                                                      quantity: business_transaction.quantity_bought,
                                                      unit_price: fee_type == :fair ? -( fair_wo_vat article ) : -( actual_fee_wo_vat business_transaction ),
                                                      description: business_transaction.id.to_s + "  " + article.title + " (#{ fee_type == :fair ? I18n.t( 'invoice.refund_fair' ) : I18n.t( 'invoice.refund_fee' ) })",
                                                      usage_date: business_transaction.sold_at.strftime("%Y-%m-%d %H:%M:%S")
                                                    )
        business_transaction.update_attribute("billed_for_#{fee_type}".to_sym, false)
    end

    # This methods calculate the fee without vat
    def self.fair_wo_vat article
      (article.calculated_fair_cents.to_f / 100 / 1.19).round(2)
    end

    def self.fee_wo_vat article
      (article.calculated_fee_cents.to_f / 100 / 1.19).round(2)
    end

    def self.discount_wo_vat business_transaction
      (business_transaction.discount_value_cents.to_f / 100 / 1.19).round(2)
    end

    def self.actual_fee_wo_vat business_transaction
      fee = fee_wo_vat( business_transaction.article )
      fee -= discount_wo_vat( business_transaction ) if business_transaction.discount
      fee
    end
end
