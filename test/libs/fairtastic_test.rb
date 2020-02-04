#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

class FairtasticTest < ActiveSupport::TestCase
  # include RSpec::Rails::HelperExampleGroup

  describe 'InputSteps' do
    before :each do
      @buffer = SpecOutputBuffer.new
    end

    describe '#input_step' do
      it 'should return input step code with additional class codex' do
        DummyClass.any_instance.stubs(:protect_against_forgery?).returns(false)
        @buffer.concat(
          helper.semantic_form_for(:template, url: '', as: 'monster', builder: Fairtastic::FormBuilder) do |f|
            f.input_step 'foo', class: 'bar'
          end
        )

        @buffer.output.must_match(/fieldset class="bar foo-step-inputs/)
      end
    end
  end
end
