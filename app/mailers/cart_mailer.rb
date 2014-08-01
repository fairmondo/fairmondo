class CartMailer < ActionMailer::Base

  default from: $email_addresses['ArticleMailer']['default_from']

  def buyer_email(cart)
    @cart = cart
    @buyer = cart.user
    @subject = "[Fairnopoly] #{ t('transaction.notifications.buyer.buyer_subject') } Einkauf Nr: #{ cart.id }"

    # needs a method that can grab all images that belong to cart and related objects and convert them to
    # inline attachments
    attachments.inline['logo-small.png'] = File.read("#{Rails.root}/public/logo-small.png")

    mail(to: @buyer.email, subject: @subject)
  end

  def seller_email(line_item_group)
    @line_item_group = line_item_group
    @buyer = line_item_group.buyer
    @seller = line_item_group.seller
    @subject = "[Fairnopoly] #{ t('transaction.notifications.seller.seller_subject') } Verkauf Nr: #{ line_item_group.id }"

    mail(to: @seller.email, subject: @subject)
  end
end
