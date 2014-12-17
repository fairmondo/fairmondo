class CartMailer < ActionMailer::Base
  include MailerHelper
  before_filter :inline_logos, except: :courier_notification

  default from: $email_addresses['default']
  layout 'email', except: :courier_notification

  def buyer_email(cart)
    cart.line_item_groups.each do |lig|
      add_image_attachments_for lig

      if lig.seller.is_a?(LegalEntity) && lig.seller.terms && lig.seller.cancellation
        filename = "#{ lig.seller_nickname }_agb_und_widerrruf.pdf"
        attachments[filename] = TermsAndCancellationPdf.new(lig).render
      end

      unless lig.business_transactions.select{|bt| bt.selected_transport == 'bike_courier'}.empty?
        filename = $courier['tos']
        attachments[filename] = File.read(Rails.root.join("app/assets/docs/#{ filename }"))
      end
    end

    @cart = cart
    @buyer = cart.user
    @subject = "[Fairmondo] #{ t('transaction.notifications.buyer.buyer_subject') } vom #{ @cart.line_item_groups.first.sold_at.strftime('%d.%m.%Y %H:%M') }"

    mail(to: @buyer.email, subject: @subject)
  end

  def seller_email(line_item_group)

    add_image_attachments_for line_item_group

    @line_item_group = line_item_group
    @buyer = line_item_group.buyer
    @seller = line_item_group.seller
    @subject = "[Fairmondo] #{ t('transaction.notifications.seller.seller_subject') } Verkauf Nr: #{ line_item_group.purchase_id }"

    mail(to: @seller.email, subject: @subject)
  end

  def courier_notification(business_transaction)
     @business_transaction = business_transaction
     @buyer           = business_transaction.buyer
     @seller          = business_transaction.seller
     @subject         = "[Fairmondo] Artikel ausliefern"
     @courier_email   = Rails.env == 'production' ? $courier['email'] : 'test@test.com'

     if business_transaction.ready? && business_transaction.line_item_group.paypal_payment.confirmed?
       mail(to: @courier_email, subject: @subject)
     end
  end

  def voucher_paid_email payment_id
    @payment = Payment.find(payment_id)
    @abacus = Abacus.new(@payment.line_item_group)

    @buyer = @payment.line_item_group_buyer
    @seller = @payment.line_item_group_seller
    @subject = "[Fairmondo] #{ t('transaction.notifications.seller.seller_voucher_subject') }"

    mail(to: @seller.email, subject: @subject)
  end

  private

    def add_image_attachments_for line_item_group
      line_item_group.business_transactions.each do |bt|
        attachment = image_attachment_for bt
        attachments.inline[bt.article.title_image.image_file_name] = attachment if attachment
      end
    end

    def image_attachment_for business_transaction
      image = business_transaction.article.title_image
      if image
        attachment = {
          content: File.read("#{ Rails.root }/#{ image.image.path(:thumb) }"),
          mime_type: image.image.content_type
        } rescue nil
        file_ext = File.extname image.image.path
        attachment
      end
    end

end
