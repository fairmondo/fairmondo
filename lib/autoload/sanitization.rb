# Sanitization DSL. Should be used for all text input fields
module Sanitization
  extend ActiveSupport::Concern
  require 'cgi'

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


          # TinyMCE contents are assumed to have HTML content and are now sanitized. So we can always give them the html_safe flag.
          if options[:method] == 'tiny_mce'
            define_method "#{field}_with_html_safe", Proc.new {
              orig = send("#{field}_without_html_safe")
              orig.is_a?(String) ? orig.html_safe : orig
            }
            define_method field, -> { read_attribute field } #no idea why this fix is needed
            alias_method_chain field, :html_safe
          end

        end
      end
    end

  private
    # Method content for sanitize_clean_X callbacks
    # @api private
    # @return [Proc]

    def clean_sanitization field, admin_mode # admin_mode not used
      Proc.new { self.send("#{field}=", Sanitization.sanitize_clean(self.send(field))) }
    end

    # Method content for sanitize_tiny_mce_X callbacks
    # @api private
    def tiny_mce_sanitization field, admin_mode
      Proc.new { self.send("#{field}=", Sanitization.sanitize_tiny_mce(self.send(field), admin_mode)) }
    end

    # Sanitization specifically for tiny mce fields which allow certain HTML elements
    #
    # @api private
    # @param field [String] The content to sanitize
    # @param admin_mode [Boolean] When true more tags are allowed
    # @return [String] The sanitized content
    def self.sanitize_tiny_mce field, admin_mode = false
      modify Sanitize.clean(
        field,
        elements: admin_mode ?
          %w(a b i strong em p h1 h2 h3 h4 h5 h6 br hr ul ol li img div span iframe) :
          %w(b i strong em p h1 h2 h3 h4 h5 h6 br hr ul ol li),
        attributes: {
          'a' => ['href', 'type', 'target'],
          'img' => ['src', 'alt'],
          'iframe' => ['src', 'frameborder'],
          :all => admin_mode ?
            ['width', 'height', 'data', 'name', 'id', 'class', 'style', 'data-truncate'] :
            ['width', 'height', 'name']
        },
        protocols: {
          'a' => { 'href' => ['http', 'https', 'mailto', :relative] },
          'img' => { 'src' => ['http', 'https', :relative] }
        }
      )
    end

    # Clean sanitization with further string modification
    #
    # @api private
    # @param field [String] The content to sanitize
    # @return [String] The sanitized content
    def self.sanitize_clean field
      # Needed because of the inject_questionnaire method in the mass_upload model (else statement)
      field = field.first if field.class == Array
      reverse_encoding modify Sanitize.clean(field)
    end

    # Modify sanitized strings even further
    # @api private
    # @param string [String, nil] The string to modify
    # @return [String] The modified string
    def self.modify string
      if string.is_a? String
        string.
          strip(). # Remove leading and trailing white space
          gsub(
          /\s+/, ' ' # Multiple whitespaces become one
        )
      else
        string
      end
    end

    # Clean sanitized fields get HTML entities encoded, which we need to revert
    # @api private
    # @param string [String, nil] The string with HTML-entities
    # @return [String] The unencoded string
    def self.reverse_encoding string
      string.is_a?(String) ? CGI.unescapeHTML(string) : string
    end
end
