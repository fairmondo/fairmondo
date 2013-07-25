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

include Warden::Test::Helpers

describe 'Commendation Validations' do

  context "for signed-in users" do

    before :each do
      @user = FactoryGirl.create :user
      login_as @user, scope: :user

    end

    describe "article creation with incorrect commendations" do
      context "social producer questionnaire" do

        before :each do
          visit new_article_path
          check "article_fair"
          within("#article_fair_kind_input") do
            choose "article_fair_kind_social_producer"
          end

        end
        it "should throw an error if you don't answer any questions" do
          find(".actions").find(".action").find("input").click
          page.should have_content I18n.t('article.form.errors.social_producer_questionnaire.no_social_producer')
        end
        it "should throw an error if you answer a question with yes but don't check a checkbox" do
          within("#article_social_producer_questionnaire_attributes_nonprofit_association_input") do
              choose "article_social_producer_questionnaire_attributes_nonprofit_association_true"
          end
          find(".actions").find(".action").find("input").click
          find("#article_social_producer_questionnaire_attributes_nonprofit_association_checkboxes_input").should have_content I18n.t('errors.messages.at_least_one_entry')
        end
      end


    end
  end
end
