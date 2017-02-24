#   Copyright (c) 2012-2017, Fairmondo eG.  This file is
#   licensed under the GNU Affero General Public License version 3 or later.
#   See the COPYRIGHT file for details.

require 'json'

# Check security
def brakeman
  puts "\n\n[Brakeman] Security Audit:\n"
  output = %x( bundle exec rake test:brakeman )
  result = JSON.parse output

  warnings = result['warnings'].length
  errors = result['errors'].length

  result['warnings'].each do |w|
    puts "Warning: #{format_brakeman_output(w)}".yellow
  end unless warnings == 0
  result['errors'].each do |e|
    puts "Error: #{format_brakeman_output(e)}".red
  end unless errors == 0

  puts "Warnings: #{warnings}"
  puts "Errors: #{errors}"

  if warnings == 0 && errors == 0
    puts 'Basic security is ensured.'.green
  else
    puts 'Security issues exist.'.red.underline
    exit 1
  end
end

def format_brakeman_output obj
  # {"warning_type"=>"Mass Assignment", "warning_code"=>17, "fingerprint"=>"27beb3195178f4d43c35b1c282a079319d44adec7cea1ed0f157905a92c92501", "message"=>"Unprotected mass assignment", "file"=>"/Users/tino/ruby/rails_projects/fairnopoly/app/controllers/articles_controller.rb", "line"=>192, "link"=>"http://brakemanscanner.org/docs/warning_types/mass_assignment/", "code"=>"Article.new(params[:article])", "render_path"=>nil, "location"=>{"type"=>"method", "class"=>"ArticlesController", "method"=>"collection"}, "user_input"=>"params[:article]", "confidence"=>"High"}
  if obj['line']
    "#{obj['message']} near line #{obj['line']}: #{obj['code']}\n#{obj['file']}\nConfidence: #{obj['confidence']}"
  else
    "#{obj['message']}.\n#{obj['file']}\nConfidence: #{obj['confidence']}"
  end
end
