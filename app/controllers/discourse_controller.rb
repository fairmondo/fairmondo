#   Copyright (c) 2012-2015, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

class DiscourseController < ApplicationController
  MAP_USER = {
    email: :email,
    name: :fullname,
    username: :nickname,
    external_id: :id }

  def sso
    secret = DISCOURSE_SECRET
    sso = SingleSignOn.parse(request.query_string, secret)
    MAP_USER.each do |k, v|
      sso.send("#{k}=", current_user.send(v))
    end
    sso.sso_secret = secret

    redirect_to sso.to_url(DISCOURSE_URL)
  end
end
