### Helper Specs ###

class DummyClass < ActionView::Base
  include Rails.application.routes.url_helpers

  # include all of our helpers here
  include AccordionHelper
  include ApplicationHelper
  include ArticlesHelper
  include BusinessTransactionHelper
  include BusinessTransactionMailerHelper
  include CommendationHelper
  include ContentHelper
  include LibraryHelper
  include NoticeHelper
  include SearchHelper
  include StatisticHelper
  include UsersHelper
  include WelcomeHelper
end
Rails.application.default_url_options = Rails.application.config.action_mailer.default_url_options = { host: "example.com" }

def helper
  @helper ||= DummyClass.new
end
