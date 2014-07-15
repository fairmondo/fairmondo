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
require_relative '../test_helper'

describe Library do
  subject { Library.new }

  describe "associations" do
    it { subject.must have_many(:library_elements) }
    it { subject.must have_many(:articles) }
    it { subject.must belong_to :user }
    it { subject.must have_many(:hearts) }
    it { subject.must have_many(:comments) }
  end

  describe "model attributes" do
    it { subject.must_respond_to :id }
    it { subject.must_respond_to :created_at }
    it { subject.must_respond_to :updated_at }
    it { subject.must_respond_to :name }
    it { subject.must_respond_to :public }
    it { subject.must_respond_to :user }
    it { subject.must_respond_to :user_id }
    it { subject.must_respond_to :library_elements_count }
    it { subject.must_respond_to :hearts_count }
  end

  describe "validations" do
    describe "for name" do
      it { subject.must validate_presence_of(:name) }
      it { subject.must validate_uniqueness_of(:name).scoped_to(:user_id) }
      it { subject.must ensure_length_of(:name).is_at_most(70) }
    end

    describe "for user" do
      it { subject.must validate_presence_of(:user) }
    end
  end
end
