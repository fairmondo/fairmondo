# frozen_string_literal: true

require "test_helper"

# Capybara.asset_host = "http://localhost:3000"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400],
            options: { args: ["headless", "disable-gpu", "no-sandbox", "disable-dev-shm-usage"] }

  include Devise::Test::IntegrationHelpers
end
