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

describe 'Fairtastic' do
  #include RSpec::Rails::HelperExampleGroup

  describe "InputSteps" do
    before :each do
      @buffer = SpecOutputBuffer.new
    end

    describe "#input_step" do
      it "should return input step code with additional class codex" do
        @buffer.concat(
          helper.semantic_form_for(:template, :url => '', as: 'monster', :builder => Fairtastic::FormBuilder) do |f|
            f.input_step 'foo', class: 'bar'
          end
        )

        @buffer.output.must_match(/fieldset class="bar foo-step-inputs/)
      end
    end
  end
end
