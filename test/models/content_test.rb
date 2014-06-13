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
require 'test_helper'

describe Content do
  describe 'attributes' do
    it { should respond_to :key }
    it { should respond_to :body }
    it { should respond_to :id }
    it { should respond_to :created_at }
    it { should respond_to :updated_at }
  end

  describe "fields" do
    describe "friendly_id" do
      # see https://github.com/norman/friendly_id/issues/332
      it "find by slug should work" do
        content = FactoryGirl.create :content
        Content.find(content.key).should eq content
      end
    end

  end

  describe "validations" do
    it { should validate_presence_of :key }
  end
end
