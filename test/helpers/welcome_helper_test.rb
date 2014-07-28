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

describe WelcomeHelper do


  describe "#rss_image_extractor" do
    it "returns an image when there is one" do
      content = "<p><img src=\"test.png\"/>"
      result = ' <img src="test.png"> '
      additional = " test test"
      helper.rss_image_extractor(content + additional).must_equal result
    end
    it "returns empty string with no image present" do
      content = "<p> testt test</p>"
      helper.rss_image_extractor(content).must_equal ''
    end

  end


end
