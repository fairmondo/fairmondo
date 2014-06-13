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
require "test_helper"

describe ApplicationHelper do
  # describe "#params_without(key)" do
  #   it "should return params without the given key" do
  #     controller.params = {a: 'b', deleteme: 'c'}
  #     result = helper.params_without :deleteme
  #     result.should have_key :a
  #     result.should_not have_key :deleteme
  #   end
  # end

  # describe "#params_without_reset_page" do
  #   it "should return params without 'page' and the given key" do
  #     controller.params = {a: 'b', deleteme: 'c', 'page' => 'd'}
  #     result = helper.params_without_reset_page :deleteme
  #     result.should have_key :a
  #     result.should_not have_key :deleteme
  #     result.should_not have_key 'page'
  #   end
  # end

  # describe "#params_with(key, value)" do
  #   it "should return params with the given data" do
  #     controller.params = {a: 'b'}
  #     result = helper.params_with :b, 'c'
  #     result.should have_key :a
  #     result[:b].should eq 'c'
  #   end
  # end

  # describe "#params_replace(old, new, value)" do
  #   it "should return params a replaced key" do
  #     controller.params = {old: 'foobar'}
  #     result = helper.params_replace :old, :new, 'bazfuz'
  #     result.should_not have_key :old
  #     result[:new].should eq 'bazfuz'
  #   end
  # end
end
