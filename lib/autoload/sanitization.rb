# Sanitization DSL. Should be used for all text input fields
module Sanitization
  extend ActiveSupport::Concern

  protected
  # DSL method to sanitize specific fields automatically before the validation step
  #
  # @api semipublic
  # @param fields [Symbol] As many ActiveRecord fields as you like
  # @param options [Hash] (Optional)
  #   :method - default: 'clean' | others: 'tiny_mce'
  #   :admin  - default:  false  | allows more elements when true
  #   + other before_validate params
  # @return [undefined]
  def auto_sanitize *fields
    options = {} unless (options = fields.last).is_a? Hash
    options.reverse_merge! method: 'clean', admin: false

    # For each field: define a new method, then register a callback to that method
    fields.each do |field|
      if field.is_a? Symbol
        method_name = "sanitize_#{options[:method]}_#{field}"
        define_method method_name, send("#{options[:method]}_sanitization", field, options[:admin])
        before_validation method_name.to_sym, options
      end
    end
  end

  private
  # Method content for sanitize_clean_X callbacks
  # @api private
  def clean_sanitization field, admin_mode # admin_mode not used
    Proc.new { self.send("#{field}=", Sanitize.clean(self.send(field))) }
  end

  # Method content for sanitize_tiny_mce_X callbacks
  # @api private
  def tiny_mce_sanitization field, admin_mode
    Proc.new { self.send("#{field}=", Sanitization.sanitize_tiny_mce(self.send(field), admin_mode)) }
  end

  # Sanitization specifically for tiny mce fields which allow certain HTML
  # elements.
  #
  # @api private
  # @param field [Sting] The content to sanitize
  # @param admin_mode [Boolean] When true more tags are allowed
  # @return [String] The sanitized content
  def self.sanitize_tiny_mce field, admin_mode = false
    Sanitize.clean(field,
      elements: admin_mode ?
        %w(a b i strong em p h1 h2 h3 h4 h5 h6 br hr ul li img div span) :
        %w(a b i strong em p h1 h2 h3 h4 h5 h6 br hr ul li img),
      attributes: {
        'a' => admin_mode ?
          ['href', 'type', 'target'] :
          ['href', 'type'],
        'img' => ['src'],
        :all => admin_mode ?
          ['width', 'height', 'data', 'name', 'id', 'class', 'style'] :
          ['width', 'height', 'data', 'name']
      },
      protocols: {
        'a' => { 'href' => ['http', 'https', 'mailto', :relative] },
        'img' => { 'src' => ['http', 'https'] }
      }
    )
  end

end
