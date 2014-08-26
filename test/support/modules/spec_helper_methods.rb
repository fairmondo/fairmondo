### Helper Specs ###

class DummyClass < ActionView::Base
  include Rails.application.routes.url_helpers

  # include all of our helpers here
  include ContainerHelper
  include ApplicationHelper
  include ArticlesHelper
  include CommendationHelper
  include ContentHelper
  include NoticeHelper
  include SearchHelper
  include StatisticHelper
  include UsersHelper
  include WelcomeHelper
  include CommentsHelper
end
Rails.application.default_url_options = Rails.application.config.action_mailer.default_url_options = { host: "localhost:3000" }

def helper
  @helper ||= DummyClass.new
end
