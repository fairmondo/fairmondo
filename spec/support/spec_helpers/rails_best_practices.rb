# Check for best practices
RSpec.configure do |config|
  config.after :suite do
    unless $skip_audits
      puts "\n\n[RailsBestPractices] Testing:\n".underline
      bp_analyzer = RailsBestPractices::Analyzer.new(Rails.root, {})
      bp_analyzer.analyze

      # Console output:
      bp_analyzer.output

      # Generate HTML as well:
      options = bp_analyzer.instance_variable_get :@options
      bp_analyzer.instance_variable_set :@options, options.merge({'format' => 'html'})
      bp_analyzer.output

    exit bp_analyzer.runner.errors.size
  end
end
