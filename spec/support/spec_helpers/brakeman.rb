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
require 'json'

# Check security
def brakeman
  puts "\n\n[Brakeman] Security Audit:\n".underline
  result = JSON.parse %x( bundle exec rake test:brakeman )

  warnings = result['warnings'].length
  errors = result['errors'].length

  result['warnings'].each {|w| puts "Warning: #{format(w)}".yellow } unless warnings == 0
  result['errors'].each {|e| puts "Error: #{format(e)}".red } unless errors == 0

  puts "Warnings: #{warnings}"
  puts "Errors: #{errors}"

  if warnings == 0 && errors == 0
    puts "Basic security is ensured.".green
  else
    puts "Security issues exist.".red.underline
    $suite_failing = true
  end
end

def format obj
  # {"warning_type"=>"Mass Assignment", "warning_code"=>17, "fingerprint"=>"27beb3195178f4d43c35b1c282a079319d44adec7cea1ed0f157905a92c92501", "message"=>"Unprotected mass assignment", "file"=>"/Users/tino/ruby/rails_projects/fairnopoly/app/controllers/articles_controller.rb", "line"=>192, "link"=>"http://brakemanscanner.org/docs/warning_types/mass_assignment/", "code"=>"Article.new(params[:article])", "render_path"=>nil, "location"=>{"type"=>"method", "class"=>"ArticlesController", "method"=>"collection"}, "user_input"=>"params[:article]", "confidence"=>"High"}
  if obj['line']
    "#{obj['message']} near line #{obj['line']}: #{obj['code']}\n#{obj['file']}\nConfidence: #{obj['confidence']}"
  else
    "#{obj['message']}.\n#{obj['file']}\nConfidence: #{obj['confidence']}"
  end
end
