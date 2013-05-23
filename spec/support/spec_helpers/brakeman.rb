require 'json'

# Check security
def audit_security
  puts "\n[Brakeman] Security Testing:".underline
  result = JSON.parse %x( bundle exec rake test:brakeman )

  warnings = result['warnings'].length
  errors = result['errors'].length

  result['warnings'].each {|w| puts "Warning: #{format(w)}".yellow } unless warnings == 0
  result['errors'].each {|e| puts "Error: #{format(e)}".red } unless errors == 0

  puts "Warnings: #{warnings}"
  puts "Errors: #{errors}"

  if warnings == 0 && errors == 0
    puts "Perfect. Basic security is ensured.".green
  else
    puts "Please remove all errors and warnings before pushing.".red.underline
  end
end

def format obj
  # Warning: {"warning_type"=>"Mass Assignment", "warning_code"=>17, "fingerprint"=>"27beb3195178f4d43c35b1c282a079319d44adec7cea1ed0f157905a92c92501", "message"=>"Unprotected mass assignment", "file"=>"/Users/tino/ruby/rails_projects/fairnopoly/app/controllers/articles_controller.rb", "line"=>192, "link"=>"http://brakemanscanner.org/docs/warning_types/mass_assignment/", "code"=>"Article.new(params[:article])", "render_path"=>nil, "location"=>{"type"=>"method", "class"=>"ArticlesController", "method"=>"collection"}, "user_input"=>"params[:article]", "confidence"=>"High"}
  # Warning: {"warning_type"=>"Attribute Restriction", "warning_code"=>19, "fingerprint"=>"3bf5a09b628265e15d6023e8658859667d9da6a9c3c0ac3b98e4a1901dac932f", "message"=>"Mass assignment is not restricted using attr_accessible", "file"=>"/Users/tino/ruby/rails_projects/fairnopoly/app/models/article.rb", "line"=>nil, "link"=>"http://brakemanscanner.org/docs/warning_types/attribute_restriction/", "code"=>nil, "render_path"=>nil, "location"=>{"type"=>"model", "model"=>"Article"}, "user_input"=>nil, "confidence"=>"High"}
  obj
end