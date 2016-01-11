#   Copyright (c) 2012-2016, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

# Little convenience matchers for MiniTest
class String
  # a must_include that implicitly converts into string
  def must_contain substring
    substring = "" unless substring # must_include throws errors on nil
    substring = substring.to_s unless substring.is_a? String
    self.must_include substring
  end
end
