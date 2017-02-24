#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

if Rails.env.production?
  DISCOURSE_SECRET = Rails.application.secrets.discourse_secret
  DISCOURSE_URL    = Rails.application.secrets.discourse_url
else
  DISCOURSE_SECRET = 'd836444a9e4084d5b224a60c208dce14'
  DISCOURSE_URL = 'http://test.de/sessions/sso_login'
end
