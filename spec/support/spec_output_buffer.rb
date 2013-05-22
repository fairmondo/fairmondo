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