if Rails.env.production?
  DISCOURSE_SECRET = Rails.application.secrets.discourse_secret
  DISCOURSE_URL    = Rails.application.secrets.discourse_url
else
  DISCOURSE_SECRET = 'd836444a9e4084d5b224a60c208dce14'
  DISCOURSE_URL = 'http://test.de/sessions/sso_login'
end
