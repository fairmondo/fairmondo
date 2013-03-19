module Auction::Search
  extend ActiveSupport::Concern
  
  included do
  
    acts_as_indexed :fields => [:title, :content]
    skip_callback :update, :before, :update_index, :if => :template? 
    skip_callback :create, :after, :add_to_index, :if => :template?

  end
  
  #little dirty but is replaced by solr
  def update_index
    Auction.unscoped do
      self.class.index_update(self)
    end
  end
  
  
end