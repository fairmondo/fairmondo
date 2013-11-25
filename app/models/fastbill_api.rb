class FastbillAPI
  require 'fastbill-automatic'

  
  #Here be FastBill stuff
  #TODO verhindern, dass je Nutzer zwei Kontos angelegt werden, schauen warum das mt den Abos nicht hinhaut
  #TODO Logger für fehlerhandling
  #TODO asynchron

  def self.fastbill_chain transaction
    seller = User.find(transaction.seller_id)

    unless seller.ngo?
      unless seller.has_fastbill_profile?
        fastbill_create_customer seller
        fastbill_create_subscription seller
      end
      fastbill_setusagedata seller, transaction, :fair
      fastbill_setusagedata seller, transaction, :fee
    end
  end

  private
    def self.fastbill_create_customer seller
      customer = Fastbill::Automatic::Customer.create( customer_number: seller.id,
                                            customer_type: seller.is_a?(LegalEntity) ? 'business' : 'consumer',
                                            organization: seller.company_name? ? seller.company_name : seller.nickname,
                                            salutation: seller.title,
                                            first_name: seller.forename,
                                            last_name: seller.surname,
                                            address: seller.street,
                                            address_2: seller.address_suffix,
                                            zipcode: seller.zip,
                                            city: seller.city,
                                            country_code: 'DE',
                                            language_code: 'DE',
                                            email: seller.email,
                                            currency_code: 'EUR',
                                            payment_type: '2',
                                            show_payment_notice: '1',
                                            bank_name: seller.bank_name,
                                            bank_code: seller.bank_code,
                                            bank_account_number: seller.bank_account_number,
                                            bank_account_owner: seller.bank_account_owner
                                          )
      seller.fastbill_id = customer.customer_id
      seller.has_fastbill_profile = true
      seller.save
    end
    
    def self.fastbill_update_user user
      customer = Fastbill::Automatic::Customer.get( customer_number: user.fastbill_id ).first
      if customer
        customer.update_attributes( customer_id: user.fastbill_id,
                                  customer_type: "#{ user.is_a?(LegalEntity) ? 'business' : 'consumer' }",
                                  organization: "#{ user.company_name if user.is_a?(LegalEntity) }",
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
                                  payment_type: '2',
                                  show_payment_notice: '1',
                                  bank_name: user.bank_name,
                                  bank_code: user.bank_code,
                                  bank_account_number: user.bank_account_number,
                                  bank_account_owner: user.bank_account_owner
                                )
      end
    end

    def self.fastbill_create_subscription seller
      subscription = Fastbill::Automatic::Subscription.create( article_number: '10',
                                                customer_id: seller.fastbill_id
                                              )
      seller.fastbill_subscription_id = subscription.subscription_id
      seller.save
    end
      
    def self.fastbill_setusagedata seller, transaction, fee_type
      article = transaction.article

      Fastbill::Automatic::Subscription.setusagedata( subscription_id: seller.fastbill_subscription_id,
                                                      article_number: fee_type == :fair ? '11' : '12',
                                                      quantity: transaction.quantity_bought,
                                                      unit_price: fee_type == :fair ? (article.calculated_fair_cents / 100.0) : (article.calculated_fee_cents / 100.0),
                                                      description: article.title + " (#{ fee_type == :fair ? 'Faires Prozent' : 'Verkaufsgebuehr'})",
                                                      usage_date: transaction.sold_at.strftime("%H:%M:%S %Y-%m-%d")
                                                    )
    end

    def self.fastbill_refund seller, transaction, fee_type
      article = transaction.article

      Fastbill::Automatic::Subscription.setusagedata( subscription_id: seller.fastbill_subscription_id,
                                                      article_number: fee_type == :fair ? '11' : '12',
                                                      quantity: transaction.quantity_bought,
                                                      unit_price: fee_type == :fair ? ( 0 - article.calculated_fair_cents / 100.0 ) : ( 0 - article.calculated_fee_cents / 100.0 ),
                                                      description: article.title + " (#{ fee_type == :fair ? 'Rueckerstattung Faires Prozent' : 'Rueckerstattung Verkaufsgebuehr'})",
                                                      usage_date: transaction.sold_at.strftime("%H:%M:%S %Y-%m-%d")
                                                    )
    end
end
