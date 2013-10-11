#
#
# == License:
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

include Warden::Test::Helpers

describe 'Rating' do
  let(:transaction) { FactoryGirl.create :single_transaction, :sold }
  let(:buyer) { transaction.buyer }
  let(:user) { FactoryGirl.create :user }

  context "for a logged-out user" do
    it "should not yet be accessible" do
      visit transaction_new_user_rating_path(transaction.seller, transaction)
      current_path.should eq new_user_session_path
    end
  end

  context "for logged-in user who is not buyer" do
    before { login_as user }

    describe "with user not as transaction buyer" do
      it "should not show the correct data and fields" do
        expect do
          visit transaction_new_user_rating_path(transaction.seller, transaction)
        end.to raise_error Pundit::NotAuthorizedError
      end
    end
  end

  context "for a logged-in buyer" do
    before { login_as buyer }

    describe "with user as transaction buyer" do
      it "should show the correct data and fields" do
        visit transaction_new_user_rating_path(transaction.seller, transaction)
        page.should have_css 'form'
        page.should have_css "input#rating_rating_positive[@value='positive']"
        page.should have_css "input#rating_rating_neutral[@value='neutral']"
        page.should have_css "input#rating_rating_negative[@value='negative']"
        page.should have_css "textarea"

        page.should have_button 'Bewertung speichern'
      end

      it "should fail when saving without a selected rating" do
        visit transaction_new_user_rating_path(transaction.seller, transaction)
        click_button 'Bewertung speichern'
        current_path.should eq user_path(buyer)
        page.should have_content 'Deine Bewertung wurde nicht gespeichert'
      end

      it "should succeed when saving with a selected rating" do
        visit transaction_new_user_rating_path(transaction.seller, transaction)
        choose 'rating_rating_positive'
        click_button 'Bewertung speichern'
        current_path.should eq user_path(buyer)
        page.should have_content 'Deine Bewertung wurde gespeichert'
      end
    end

  end


end