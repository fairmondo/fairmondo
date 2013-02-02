class AuctionTemplatesController < InheritedResources::Base
  
  before_filter :authenticate_user!
  before_filter :setup_categories, :only => [:new, :edit]
  
  actions :all, :except => [:show]
  
  def begin_of_association_chain
    current_user
  end
  
  def create
    create! do |success, failure|
      success.html { redirect_to collection_url }
    end
  end
  
  def update
    update! do |success, failure|
      success.html { redirect_to collection_url }
    end
  end
  
end
