#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class UserObserver < ActiveRecord::Observer
  def before_save user
    if user.iban_changed? || user.bic_changed?
      check_bic_and_iban(user.id, user.iban, user.bic)
    end
  end

  def after_update user
    update_fastbill_account_for user
    update_cleverreach_settings_for user
    deactivate_and_close_active_articles_for_banned user
  end

  def after_create user
    CleverreachAPI.add(user) if user.newsletter?
  end

  private

  def update_fastbill_account_for user
    # this should update the users data with fastbill after the user edits his data
    if user.fastbill_profile_update
      user.update_fastbill_profile
    end
  end

  def update_cleverreach_settings_for user
    if user.saved_change_to_newsletter?
      cr = CleverreachAPI
      user.newsletter? ? cr.add(user) : cr.remove(user)
    end
  end

  def deactivate_and_close_active_articles_for_banned user
    # deactivates and closes all active articles of banned user
    if user.banned && user.articles.active.limit(1).any?
      user.articles.active.find_each do |article|
        article.deactivate
        article.close
      end
    end
  end

  def check_bic_and_iban(id, iban, bic)
    begin
      user = User.find(id)
      user.update_column(:bankaccount_warning, !KontoAPI.valid?(iban: iban, bic: bic))
    rescue
    end
  end
end
