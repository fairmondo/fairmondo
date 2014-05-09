# Responsible for buyer's confirmations and sales notifications.
#
# == License:
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#

class BusinessTransactionMailer < ActionMailer::Base
  include ArticlesHelper #As we want to use this in here!

	helper BusinessTransactionHelper
	helper BusinessTransactionMailerHelper
  helper ArticlesHelper

  default from: $email_addresses['ArticleMailer']['default_from']



  def buyer_notification transaction
  	@transaction 	= transaction
  	@seller 			= transaction.article_seller
  	@buyer 				= transaction.buyer
    @subject = "[Fairnopoly] #{t 'transaction.notifications.buyer.buyer_subject' } (#{transaction.article_title})"
    mail to: @buyer.email, subject: @subject
  end

  def seller_notification transaction
  	@transaction 	= transaction
  	@seller 			= transaction.article_seller
  	@buyer 				= transaction.buyer

  	@subject = "[Fairnopoly] #{t 'transaction.notifications.seller.seller_subject' } (#{transaction.article_title})"

  	if show_friendly_percent_for? transaction.article
       @subject += t('transaction.notifications.seller.with_donation_to')
       @subject += transaction.article_friendly_percent_organisation.nickname
    end

    mail to: @seller.email, subject: @subject
  end
end