#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class ConfirmationsController < Devise::ConfirmationsController
  private

  # Set parameter 'just_confirmed' so that registrations can be tracked
  def after_confirmation_path_for(resource_name, resource)
    if signed_in?(resource_name)
      signed_in_root_path(resource)
    else
      new_session_path(resource_name, just_confirmed: true)
    end
  end
end
