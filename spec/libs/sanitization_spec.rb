require "spec_helper"

def test_sanitize_mce field, admin = false
   Sanitization.send('sanitize_tiny_mce', field, admin)
end

describe 'Sanitization' do
  # private methods
  describe "::sanitize_tiny_mce" do
    context "for all users" do
      describe "sanitizing links" do
        it "should allow http protocol" do
          field = '<a href="http://www.fairnopoly.de">Test</a>'
          test_sanitize_mce(field).should eq field
        end
        it "should allow https protocol" do
          field = '<a href="https://www.fairnopoly.de">Test</a>'
          test_sanitize_mce(field).should eq field
        end
        it "should allow mailto protocol" do
          field = '<a href="mailto:info@fairnopoly.de">Test</a>'
          test_sanitize_mce(field).should eq field
        end
        it "should allow relative links" do
          field = '<a href="/somewhere">Test</a>'
          test_sanitize_mce(field).should eq field
        end
        it "should allow anchor links" do
          field = '<a href="#furtherdown">Test</a>'
          test_sanitize_mce(field).should eq field
        end
      end

      describe "sanitizing protected tags" do
        it "should disallow div and span tags + ids, classes, target, and style attributes" do
          field = '<div id="something"><span class="someclass"><a href="#x" target="_blank" style="color:red;">Test</a></span></div>'
          test_sanitize_mce(field).strip.should eq '<a href="#x">Test</a>'
        end
      end
    end

    context "for admins" do
      it "should allow div and span tags + ids, classes, target, and style attributes" do
        field = '<div id="something"><span class="someclass"><a href="#x" target="_blank" style="color:red;">Test</a></span></div>'
        test_sanitize_mce(field, true).should eq field
      end
    end
  end

end
