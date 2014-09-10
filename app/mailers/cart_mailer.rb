class CartMailer < ActionMailer::Base
  include MailerHelper
  before_filter :inline_logos

  default from: $email_addresses['default']
  layout 'email'

  def buyer_email(cart)
    cart.line_item_groups.each do |lig|
      add_image_attachments_for lig

      if lig.seller.terms && lig.seller.cancellation
        filename = "#{ lig.seller_nickname }_agb_und_widerrruf.pdf"
        attachments.inline[filename] = {
          data: TermsAndCancellationPdf.new(lig).render,
          mime_type: "application/pdf"
        }
      end
    end

    @cart = cart
    @buyer = cart.user
    @subject = "[Fairnopoly] #{ t('transaction.notifications.buyer.buyer_subject') } Einkauf Nr: #{ cart.id }"

    mail(to: @buyer.email, subject: @subject)
  end

  def seller_email(line_item_group)

    add_image_attachments_for line_item_group

    @line_item_group = line_item_group
    @buyer = line_item_group.buyer
    @seller = line_item_group.seller
    @subject = "[Fairnopoly] #{ t('transaction.notifications.seller.seller_subject') } Verkauf Nr: #{ line_item_group.purchase_id }"

    mail(to: @seller.email, subject: @subject)
  end

  private

    def add_image_attachments_for line_item_group
      line_item_group.business_transactions.each do |bt|
        attachment = image_attachment_for bt
        attachments.inline[bt.article_id.to_s] = attachment if attachment
      end
    end

    def image_attachment_for business_transaction
      image = business_transaction.article.title_image
      image ? { data: File.read("#{ Rails.root }/#{ image.image.path(:thumb) }") } : nil
    end

end
