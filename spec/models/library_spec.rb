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

describe Library do
  describe "associations" do
    it { should have_many(:library_elements).dependent(:destroy) }
    it { should have_many(:articles).through(:library_elements) }
    it { should belong_to :user }
  end

  describe "model attributes" do
    it { should respond_to :name }
    it { should respond_to :public }
    it { should respond_to :user }
    it { should respond_to :user_id }
    it { should respond_to :library_elements_count }
  end

  describe "validations" do
    context "for name" do
      it { should validate_presence_of(:name).with_message(I18n.t('library.error.presence')) }
      it { should validate_uniqueness_of(:name).scoped_to(:user_id).with_message(I18n.t('library.error.uniqueness')) }
      it { should ensure_length_of(:name).is_at_most(25).with_long_message(I18n.t('library.error.length')) } #pending "No idea why this fails... it shouldn't";
    end

    context "for user" do
      it { should validate_presence_of(:user).with_message(I18n.t('library.error.presence')) }
    end
  end
end
