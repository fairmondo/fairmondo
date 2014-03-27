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

describe FeedbacksController do

  render_views

  describe "POST 'create'" do

    before :each do
      @attributes = FactoryGirl.attributes_for :feedback, :report_article
    end

    describe "for non-signed-in users" do
      it "should create a feedback with variety report_article" do
        expect {
          post :create, feedback: @attributes
        }.to change(Feedback , :count).by 1
      end

      it "should create a feedback with variety report_article" do
        controller.stub(:verify_recaptcha).and_return(false)
        expect {
          post :create, feedback: @attributes
        }.not_to change(Feedback.all, :count)
      end

    end


  end
end





