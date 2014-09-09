class CartMailer < ActionMailer::Base
  include MailerHelper
  before_filter :inline_logos

  default from: $email_addresses['default']
  layout 'email'

  def buyer_email(cart)
    cart.line_item_groups.each do |lig|
      lig.business_transactions.each do |bt|
        unless bt.article.images.empty?
          image = bt.article.images.find_by(is_title: true).image || bt.article.images.find_by(1).image
          attachments.inline[bt.article_id.to_s] = {
            data: File.read("#{ Rails.root }/#{ image.path(:thumb) }")
                                                   }
        end
      end

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
    line_item_group.business_transactions.each do |bt|
      unless bt.article.images.empty?
        image = bt.article.images.find_by(is_title: true).image || bt.article.images.find_by(1).image
        attachments.inline[bt.article_id.to_s] = {
          data: File.read("#{ Rails.root }/#{ image.path(:thumb) }")
                                                 }
      end
    end

    @line_item_group = line_item_group
    @buyer = line_item_group.buyer
    @seller = line_item_group.seller
    @subject = "[Fairnopoly] #{ t('transaction.notifications.seller.seller_subject') } Verkauf Nr: #{ line_item_group.purchase_id }"

    mail(to: @seller.email, subject: @subject)
  end
end
