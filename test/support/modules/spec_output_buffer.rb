#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

# Output buffer for Fairtastic specs (reusable)
# http://stackoverflow.com/questions/3859565/how-do-i-test-a-formtastic-custom-input-with-rspec

class SpecOutputBuffer
  attr_reader :output

  def initialize
    @output = ''.html_safe
  end

  def concat(value)
    @output << value.html_safe
  end
end
