# frozen_string_literal: true

require 'test_helper'
require 'capybara/minitest/spec'
require 'capybara/rails'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # driven_by :selenium_chrome_headless

  driven_by :rack_test

  include Devise::Test::IntegrationHelpers

  before :each do
    CleverreachAPI.stubs(:call)
  end
end
