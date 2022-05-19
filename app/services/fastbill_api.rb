#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class FastbillAPI
  def initialize bt = nil
    if @bt = bt
      @seller  = bt.seller
      @article = bt.article
    end
  end

  # Here be FastBill stuff
  #
  # The fastbill_chain takes control of all the necessary steps to handle
  # fastbill customer creation and adding business_transactions fees to a user's
  # fastbill account
  def fastbill_chain
    @seller.with_lock do
      if @seller.needs_to_be_billed?
        unless @seller.has_fastbill_profile?
          fastbill_create_customer
          fastbill_create_subscription
        end

        [:fair, :fee].each do |type|
          send "fastbill_#{ type }"
        end

        fastbill_discount if @bt.discount
      end
    end
  end

  def update_profile user
    customer = Fastbill::Automatic::Customer.get(customer_id: user.fastbill_id).first
    if customer
      attributes = attributes_for(user)
      attributes[:customer_id] = user.fastbill_id
      customer.update_attributes(attributes)
    end
  end

  private

  def fastbill_create_customer
    unless @seller.fastbill_id
      User.observers.disable :user_observer do
        begin
          attributes = attributes_for(@seller)
          attributes[:customer_number] = @seller.id
          customer = Fastbill::Automatic::Customer.create(attributes)
          @seller.update_attribute :fastbill_id, customer.customer_id
        rescue => e
          ExceptionNotifier.notify_exception(e, data: { user: @seller })
        end
      end
    end
  end

  def attributes_for(user)
    attributes = {
      customer_type: user.is_a?(LegalEntity) ? 'business' : 'consumer',
      organization: (user.is_a?(LegalEntity) &&
                     user.standard_address_company_name.present?) ?
                     user.standard_address_company_name : user.nickname,
      salutation: user.standard_address_title,
      first_name: user.standard_address_first_name,
      last_name: user.standard_address_last_name,
      address: user.standard_address_address_line_1,
      address_2: user.standard_address_address_line_2 ? user.standard_address_address_line_2 : nil,
      zipcode: user.standard_address_zip,
      city: user.standard_address_city,
      country_code: 'DE',
      language_code: 'DE',
      email: user.email_for_invoicing,
      currency_code: 'EUR',
      payment_type: payment_type_for(user),
      show_payment_notice: '1'
    }

    case user.payment_method
    when :payment_by_invoice
      attributes.merge!(
        bank_iban: '',
        bank_bic: '',
        bank_account_owner: '',
        bank_name: '',
        bank_account_mandate_reference: '',
        bank_account_mandate_reference_date: nil,
        bank_account_number: '',
        bank_code: ''
      )
    when :payment_by_direct_debit
      attributes.merge!(
        bank_iban: user.iban,
        bank_bic: user.bic,
        bank_account_owner: user.bank_account_owner,
        bank_name: user.bank_name,
        bank_account_mandate_reference: user.active_direct_debit_mandate_reference,
        bank_account_mandate_reference_date: user.active_direct_debit_mandate_reference_date,
        bank_account_number: '',
        bank_code: ''
      )
    end

    attributes
  end

  def payment_type_for(user)
    case user.payment_method
    when :payment_by_invoice
      '1'
    when :payment_by_direct_debit
      '2'
    end
  end

  def fastbill_create_subscription
    unless @seller.fastbill_subscription_id
      User.observers.disable :user_observer do
        subscription = Fastbill::Automatic::Subscription.create(
          article_number: '10',
          customer_id: @seller.fastbill_id,
          next_event: Time.now.end_of_month.strftime('%Y-%m-%d %H:%M:%S')
        )
        @seller.update_column :fastbill_subscription_id, subscription.subscription_id
      end
    end
  end

  [:fee, :fair, :discount, :refund_fee, :refund_fair].each do |type|
    define_method "fastbill_#{ type }" do
      unless @bt.send("billed_for_#{ type }")
        begin
          Fastbill::Automatic::Subscription.setusagedata(
            subscription_id: @seller.fastbill_subscription_id,
            article_number: article_number_for(type),
            quantity: quantity_for(type),
            unit_price: unit_price_for(type),
            description: description_for(type),
            usage_date: @bt.sold_at.strftime('%Y-%m-%d %H:%M:%S')
          )
          @bt.send("billed_for_#{ type }=", true)
          @bt.save
        rescue => e
          ExceptionNotifier.notify_exception(e, data: { business_transaction: @bt, user: @seller })
        end
      end
    end
  end

  def description_for type
    if type == :discount
      "#{ @bt.id } #{ @article.title } (#{ @bt.discount_title })"
    else
      "#{ @bt.id } #{ @article.title } (#{ I18n.t('invoice.' + type.to_s) })"
    end
  end

  def quantity_for type
    if type == :discount
      '1'
    else
      @bt.quantity_bought
    end
  end

  def article_number_for type
    if type == :fair || type == :refund_fair
      11
    elsif type == :fee || type == :refund_fee
      12
    else
      nil
    end
  end

  def unit_price_for type
    case type
    when :fee
      fee_wo_vat
    when :fair
      fair_wo_vat
    when :discount
      discount_wo_vat
    when :refund_fee
      0 - actual_fee_wo_vat
    when :refund_fair
      0 - fair_wo_vat
    end
  end

  # This method calculates the fair percent fee without vat
  def fair_wo_vat
    (@article.calculated_fair_cents.to_f / 100 / 1.19).round(2)
  end

  # This method calculates the fee without vat
  def fee_wo_vat
    (@article.calculated_fee_cents.to_f / 100 / 1.19).round(2)
  end

  # This method calculates the discount without vat
  def discount_wo_vat
    0 - (@bt.discount_value_cents.to_f / 100 / 1.19).round(2)
  end

  # This method calculates the fee without the discount (without vat)
  def actual_fee_wo_vat
    fee = fee_wo_vat
    fee -= discount_wo_vat if @bt.discount
    fee
  end
end
