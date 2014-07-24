class CartMailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  default from: $email_addresses['ArticleMailer']['default_from']

  def buyer_email(cart)
    @cart = cart
    @buyer = cart.user
    @subject = "[Fairnopoly] #{ t('transaction.notifications.buyer.buyer_subject') } Einkauf Nr: #{ cart.id }"

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
