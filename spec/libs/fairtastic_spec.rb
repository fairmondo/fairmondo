require "spec_helper"

describe 'Fairtastic' do
  include RSpec::Rails::HelperExampleGroup

  describe "InputSteps" do
    before :each do
      @buffer = SpecOutputBuffer.new
    end

    describe "#input_step" do
      it "should return input step code with additional class codex" do
        @buffer.concat(
          helper.semantic_form_for(:template_select, :url => '', as: 'monster', :builder => Fairtastic::FormBuilder) do |f|
            f.input_step 'foo', class: 'bar'
          end
        )

        @buffer.output.should =~ /fieldset class="bar foo-step-inputs/
      end
    end
  end
end
