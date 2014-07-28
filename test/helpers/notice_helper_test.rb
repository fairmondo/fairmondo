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
require_relative "../test_helper"

describe NoticeHelper do
  # describe "#bootstrap_notice_mapper" do
  #   it "returns 'warning' when given :alert" do
  #     helper.bootstrap_notice_mapper(:alert).must_equal 'warning'
  #   end
  #   it "returns 'error' when given :error" do
  #     helper.bootstrap_notice_mapper(:error).must_equal 'error'
  #   end
  #   it "returns 'success' when given :notice" do
  #     helper.bootstrap_notice_mapper(:notice).must_equal 'success'
  #   end
  #   it "returns 'info' when given anything else" do
  #     helper.bootstrap_notice_mapper(:thissymboldoesntexist).must_equal 'info'
  #   end
  # end

  describe "#main_notice_mapper" do
    it "returns 'error' when given :alert" do
      helper.main_notice_mapper('alert').must_equal 'error'
    end
    it "returns 'error' when given :error" do
      helper.main_notice_mapper('error').must_equal 'error'
    end
    it "returns 'info' when given :notice" do
      helper.main_notice_mapper('notice').must_equal 'info'
    end
    it "returns 'info confirmation' when given :confirm" do
      helper.main_notice_mapper('confirm').must_equal 'confirmation'
    end
    it "returns 'info' when given anything else" do
      helper.main_notice_mapper('thisstringdoesntexist').must_equal 'info'
    end
  end

  # I hope we don't need this. MiniTest doesn't like render calls.
  # describe "#render_data_confirm" do
  #   it "should build a html page" do
  #     helper.render_data_confirm.must_be_instance_of String
  #   end
  # end

  describe "#render_open_notice" do
    it "should render an open notice " do
      notice =  FactoryGirl.create :notice
      helper.render_open_notice(notice).must_be_kind_of String
    end
  end
end
