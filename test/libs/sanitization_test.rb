#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'test_helper'

def test_sanitize_mce field, admin = false
  Sanitization.send('sanitize_tiny_mce', field, admin)
end

class SanitizationTest < ActiveSupport::TestCase
  # private methods
  describe '::sanitize_tiny_mce' do
    describe 'for standard users' do
      describe 'sanitizing protected tags' do
        it 'should disallow div and span tags + ids, classes, target, and style attributes' do
          field = '<div id="something"><span class="someclass"><a href="#x" target="_blank" style="color:red;">Test<img src="/test.jpg" alt="test"></a></span></div>'
          test_sanitize_mce(field).strip.must_equal '<a href="#x" target="_blank">Test</a>'
        end
      end
    end

    describe 'for admins' do
      it 'should allow div and span tags + ids, classes, target, and style attributes' do
        field = '<div id="something"><span class="someclass"><a href="#x" target="_blank" style="color:red;">Test<img src="/test.jpg" alt="test"></a></span></div>'
        test_sanitize_mce(field, true).must_equal field
      end

      describe 'sanitizing links' do
        it 'should allow http protocol' do
          field = '<a href="http://www.fairmondo.de">Test</a>'
          test_sanitize_mce(field, true).must_equal field
        end
        it 'should allow https protocol' do
          field = '<a href="https://www.fairmondo.de">Test</a>'
          test_sanitize_mce(field, true).must_equal field
        end
        it 'should allow mailto protocol' do
          field = '<a href="mailto:info@fairmondo.de">Test</a>'
          test_sanitize_mce(field, true).must_equal field
        end
        it 'should allow relative links' do
          field = '<a href="/somewhere">Test</a>'
          test_sanitize_mce(field, true).must_equal field
        end
        it 'should allow anchor links' do
          field = '<a href="#furtherdown">Test</a>'
          test_sanitize_mce(field, true).must_equal field
        end
      end
    end
  end
end
