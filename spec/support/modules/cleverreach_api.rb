require "savon/mock/spec_helper"

RSpec.configure do |config|
  config.include Savon::SpecHelper

  config.before(:all) { savon.mock!   }
  config.after(:all)  { savon.unmock! }
end