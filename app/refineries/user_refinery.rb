#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class UserRefinery < ApplicationRefinery
  def self.root
    false
  end

  def create
    [
      :email, :password, :new_terms_confirmed,
      # and custom fields apart from devise internal stuff:
      :nickname, :type, :newsletter, :legal, :privacy, :voluntary_contribution, :referral
    ]
  end

  def update
    permitted = [
      :current_password, # <- update specific
      :email, :password, :password_confirmation, :remember_me, :type,
      :nickname, :legal, :paypal_account, :banned,
      :about_me, :phone, :mobile, :fax,
      :company_name, :max_value_of_goods_cents_bonus,
      :fastbill_profile_update, :vacationing, :newsletter, :receive_comments_notification,
      :iban, :bic, :bank_name, :bank_account_owner, :direct_debit_confirmation,
      :unified_transport_provider, :unified_transport_maximum_articles, :unified_transport_price,
      :free_transport_available, :free_transport_at_price,
      { image_attributes: ImageRefinery.new(Image.new, user).default }
    ]
    permitted += [
      :terms, :cancellation, :about, :cancellation_form,
      :invoicing_email, :order_notifications_email
    ] if user.is_a? LegalEntity
    permitted
  end
end
