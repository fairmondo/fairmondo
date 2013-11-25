#
# Farinopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Farinopoly.
#
# Farinopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Farinopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Farinopoly.  If not, see <http://www.gnu.org/licenses/>.
#
require 'spec_helper'

describe ExhibitsController do
  context "for logged in users" do

    before :each do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    it "should throw a pundit error for create" do
      expect {
          post :create
        }.to raise_error(Pundit::NotAuthorizedError)
    end

    it "should throw a pundit error for create_multiple" do
      expect {
          post :create_multiple
        }.to raise_error(Pundit::NotAuthorizedError)
    end

  end

  context "admin users" do

    before :each do

      @user = FactoryGirl.create(:admin_user)
      sign_in @user

    end

    it "should be able to create multiple exhibitions" do
      #@exhibit_attrs = FactoryGirl.attributes_for :exhibit
       #@exhibit_attrs = FactoryGirl.attributes_for :exhibit
       #@exhibit_attrs[:queue] = :queue2
      articles = FactoryGirl.create_list(:article,3)
      article_ids = articles.map{|a| a.id.to_s }

      lambda do
        post :create_multiple, {:exhibit => {:queue => :queue2, :articles => article_ids}}
      end.should change(Exhibit.unscoped, :count).by 3
    end

    it "should be able to set new exhebitions" do
      @exhibit_attrs = FactoryGirl.attributes_for :exhibit
      @exhibit_attrs[:article_id] = FactoryGirl.create(:article).id
      lambda do
          post :create, exhibit: @exhibit_attrs
        end.should change(Exhibit.unscoped, :count).by 1
    end

    it "should destroy a exhibition" do
      @exhibit = FactoryGirl.create(:exhibit)

        expect {
          delete :destroy, :id => @exhibit
        }.to change(Exhibit, :count).by(-1)
    end

    it "should be able to set a dreamteam" do
      @exhibit = FactoryGirl.create(:exhibit)
      @related = FactoryGirl.create(:article)
      @update_attrs = {:related_article_id => @related.id}


      put :update, id: @exhibit.id , exhibit: @update_attrs

      @exhibit.reload.related_article.should == @related
    end

  end




end