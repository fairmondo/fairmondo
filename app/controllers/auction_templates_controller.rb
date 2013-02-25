class AuctionTemplatesController < InheritedResources::Base
  
  before_filter :authenticate_user!
  before_filter :build_resource, :only => [:new]
  before_filter :build_auction, :only => [:new]
  before_filter :setup_categories, :only => [:new, :edit]
  before_filter :build_questionnaires, :only => [:new, :edit]
  
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
  
  private 
  
  def build_auction
    resource.build_auction unless resource.auction 
  end
  
  def build_questionnaires
    resource.auction.build_fair_trust_questionnaire unless resource.auction.fair_trust_questionnaire
    resource.auction.build_social_producer_questionnaire unless resource.auction.social_producer_questionnaire
  end
end
