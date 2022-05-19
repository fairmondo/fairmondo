#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class NoticeHelperTest < ActionView::TestCase
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

  describe '#main_notice_mapper' do
    it "returns 'error' when given 'alert'" do
      helper.main_notice_mapper('alert').must_equal 'error'
    end
    it "returns 'error' when given 'error'" do
      helper.main_notice_mapper('error').must_equal 'error'
    end
    it "returns 'info' when given 'notice'" do
      helper.main_notice_mapper('notice').must_equal 'info'
    end
    it "returns 'info confirmation' when given 'confirm'" do
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
end
