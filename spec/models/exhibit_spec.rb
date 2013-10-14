require 'spec_helper'

describe Exhibit do
  let(:exhibit) { Exhibit.new }

  describe "::Base" do
    describe "associations" do
      it {should belong_to :article}
      it {should belong_to :related_article}

    end
  end

  describe "#independent_queue" do
    before do
      @exhibit = FactoryGirl.create(:exhibit)
    end
    it "should return two articles with valid exhibits and set exhibition date" do
      @exhibit2 = FactoryGirl.create(:exhibit)
      @articles = Exhibit.independent_queue :pioneer
      @articles.should =~ [@exhibit.article,@exhibit2.article]
      @exhibit.reload.exhibition_date.should_not be nil
      @exhibit2.reload.exhibition_date.should_not be nil
    end

    it "should not return an article on inactive article exhibition " do
      @exhibit.article.deactivate
      @articles = Exhibit.independent_queue :pioneer, 1
      @articles.should be_empty
    end

    it "should return the next two articles on inactive article exhibition " do
      @exhibit.article.deactivate
      @exhibit2 = FactoryGirl.create(:exhibit)
      @exhibit3 = FactoryGirl.create(:exhibit)
      @articles = Exhibit.independent_queue :pioneer
      @articles.should =~ [@exhibit2.article,@exhibit3.article]
    end

    it "should not return an article that was already shown 24 h " do
      @exhibit2 = FactoryGirl.create(:exhibit,:old)
      @exhibit2.created_at = DateTime.now - 1.hour #that this one is first in queue
      @articles = Exhibit.independent_queue :pioneer, 1
      @articles.should eq [@exhibit.article]
    end

    it "should work off the queue sequentially" do
     @exhibit2 = FactoryGirl.create(:exhibit)
     @exhibit2.update_attribute(:created_at,DateTime.now - 1.hour) #that this one is first in queue
     @articles = Exhibit.independent_queue :pioneer, 1
     @articles.should eq [@exhibit2.article]
    end


  end

  describe "#relation_queue" do
    before do
      @exhibit = FactoryGirl.create(:exhibit,:dream_team)
    end

    it "should return two articles with valid exhibits and set exhibition date" do
      @articles = Exhibit.relation_queue :dream_team
      @articles.should =~ [@exhibit.article,@exhibit.related_article]
      @exhibit.reload.exhibition_date.should_not be nil
    end

    it "should not return an article without the related one " do
      @exhibit.article.deactivate
      @articles = Exhibit.relation_queue :dream_team
      @articles.should be_empty
    end

    it "should return the next dream team on inactive article exhibition " do
      @exhibit.article.deactivate
      @exhibit2 = FactoryGirl.create(:exhibit,:dream_team)
      @articles = Exhibit.relation_queue :dream_team
      @articles.should =~ [@exhibit2.article,@exhibit2.related_article]
    end

    it "should not return an article that was already shown 24 h " do
      @exhibit2 = FactoryGirl.create(:exhibit,:old,:dream_team)
      @exhibit2.created_at = DateTime.now - 1.hour #that this one is first in queue
      @articles = Exhibit.relation_queue :dream_team
      @articles.should =~ [@exhibit.article,@exhibit.related_article]
    end

    it "should work off the queue sequentially" do
      @exhibit2 = FactoryGirl.create(:exhibit,:dream_team)
      @exhibit2.update_attribute(:created_at,DateTime.now - 1.hour) #that this one is first in queue
      @articles = Exhibit.relation_queue :dream_team
      @articles.should =~ [@exhibit2.article,@exhibit2.related_article]
    end

  end



end
