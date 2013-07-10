#
# Fairnopoly - Fairnopoly is an open-source online marketplace.
# Copyright (C) 2013 Fairnopoly eG
#
# This file is part of Fairnopoly.
#
# Fairnopoly is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Fairnopoly is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Fairnopoly.  If not, see <http://www.gnu.org/licenses/>.
#
require 'spec_helper'

describe FeedbacksController do

  render_views

  describe "POST 'create'" do

    before :each do
      @user = FactoryGirl.create(:user)
      @article = FactoryGirl.create(:article)
    end

    describe "for non-signed-in users" do
      it "should not create an feedback with type report_article" do
        lambda do
          begin
            post :create, :user_id => @user, :article_id => @article, :type => :report_article, :text => "test"
          rescue
            # Rescue Pundit::NotAuthorizedError #=> This test should probably be just a pundit test.
          end
        end.should_not change(Feedback, :count)
      end
    end

    describe "for signed-in users" do

      before :each do
        sign_in @user
      end

     # it "should create an feedback with type report_article" do
     #   lambda do
     #     post :create, :user_id => @user.id, :article_id => @article.id, :type => "send_feedback", :text => "test"
     #   end.should change(Feedback , :count).by 1
     # end

    end
  end
end





