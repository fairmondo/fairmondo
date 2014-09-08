class CartMailer < ActionMailer::Base
  include MailerHelper
  before_filter :inline_logos

  default from: $email_addresses['ArticleMailer']['default_from']
  layout 'email'

  def buyer_email(cart)
    cart.line_item_groups.each do |lig|
      lig.business_transactions.each do |bt|
        attachments.inline[bt.article_id.to_s] = {
        data: File.read("#{ Rails.root }/public#{ bt.article.title_image_url(:thumb) }")
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
      attachments.inline[bt.article_id.to_s] = {
        data: File.read("#{ Rails.root }/public#{ bt.article.title_image_url(:thumb) }")
                                               }
    end

    @line_item_group = line_item_group
    @buyer = line_item_group.buyer
    @seller = line_item_group.seller
    @subject = "[Fairnopoly] #{ t('transaction.notifications.seller.seller_subject') } Verkauf Nr: #{ line_item_group.purchase_id }"

    mail(to: @seller.email, subject: @subject)
  end

end
