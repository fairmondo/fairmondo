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
      it { should validate_presence_of(:name) }
      it { should validate_uniqueness_of(:name).scoped_to(:user_id) }
      it { should ensure_length_of(:name).is_at_most(70) }
    end

    context "for user" do
      it { should validate_presence_of(:user) }
    end
  end
end
