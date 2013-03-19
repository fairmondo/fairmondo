module Auction::Search
  extend ActiveSupport::Concern
  
  included do
    searchable :unless => :template? do
      text :title, :boost => 5.0, :stored => true
      text :content
      boolean :fair
      boolean :ecologic
      boolean :small_and_precious
      boolean :active
      string :condition
      integer :category_ids, :references => Category, :multiple => true
    end
  
    # Indexing via Delayed Job Daemon
    handle_asynchronously :solr_index, queue: 'indexing', priority: 50
    handle_asynchronously :solr_index!, queue: 'indexing', priority: 50
  
   
    alias_method_chain :remove_from_index, :delayed

  end
  
  def remove_from_index_with_delayed
    Delayed::Job.enqueue RemoveIndexJob.new(record_class: self.class.to_s, attributes: self.attributes), queue: 'indexing', priority: 50
  end
    
  
end