# Sanitization DSL. Should be used for all text input fields
module Sanitization
  extend ActiveSupport::Concern

  protected
  # DSL method to sanitize specific fields automatically before the validation
  # step.
  #
  # @api semipublic
  # @param fields [Symbol] As many ActiveRecord fields as you like
  # @param options [Hash] (Optional)
  #   :method - default: 'clean' | others: 'tiny_mce'
  #   + other before_validate params
  # @return [undefined]
  def auto_sanitize *fields
    options = {} unless (options = fields.last).is_a? Hash
    options.reverse_merge! method: 'clean'

    # For each field: define a new method, then register a callback to that method
    fields.each do |field|
      if field.is_a? Symbol
        method_name = "sanitize_#{options[:method]}_#{field}"
        define_method method_name, send("#{options[:method]}_sanitization", field)
        before_validation method_name.to_sym, options
      end
    end
  end

  private
  # Method content for sanitize_clean_X callbacks
  # @api private
  def clean_sanitization field
    Proc.new { self.send("#{field}=", Sanitize.clean(self.send(field))) }
  end

  # Method content for sanitize_tiny_mce_X callbacks
  # @api private
  def tiny_mce_sanitization field
    Proc.new { self.send("#{field}=", Sanitization.sanitize_tiny_mce(self.send(field))) }
  end

  # Sanitization specifically for tiny mce fields which allow certain HTML
  # elements.
  #
  # @api private
  # @param field [Sting] The content to sanitize
  # @return [String] The sanitized content
  def self.sanitize_tiny_mce field
    Sanitize.clean(field,
      elements: %w(a b i strong em p h1 h2 h3 h4 h5 h6 br hr ul li img),
      attributes: {
        'a' => ['href', 'type'],
        'img' => ['src'],
        :all => ['width', 'height', 'style', 'data', 'name']
      },
      protocols: {
        'a' => { 'href' => ['ftp', 'http', 'https', 'mailto'] },
        'img' => { 'src' => ['http', 'https'] }
      }
    )
  end

end
