require 'friendly_id'
module Tinycms
  class Content < ActiveRecord::Base
    attr_accessible :body, :key
    extend FriendlyId
    friendly_id :key
  end
end
