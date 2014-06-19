# Little convenience matchers for MiniTest
class String
  # a must_include that implicitly converts into string
  def must_contain substring
    substring = "" unless substring # must_include throws errors on nil
    substring = substring.to_s unless substring.is_a? String
    self.must_include substring
  end
end