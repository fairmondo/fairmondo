class DiscourseController < ApplicationController
  def sso
    secret = $DISCOURSE_SECRET
    sso = SingleSignOn.parse(request.query_string, secret)
    sso.email = current_user.email
    sso.name = current_user.fullname if current_user.fullname
    sso.username = current_user.nickname
    sso.external_id = current_user.id
    sso.sso_secret = secret

    redirect_to sso.to_url($DISCOURSE_URL)
  end
end
