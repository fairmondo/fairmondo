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
      options.reverse_merge! method: 'clean', admin: false, remove_all_spaces: false

      # For each field: define a new method, then register a callback to that method
      fields.each do |field|
        if field.is_a? Symbol
          method_name = "sanitize_#{options[:method]}_#{field}"
          define_method method_name, send("#{options[:method]}_sanitization", field, options[:admin], options[:remove_all_spaces])
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
    def clean_sanitization field, admin_mode, remove_spaces_mode # admin_mode not used
      Proc.new { self.send("#{field}=", Sanitization.sanitize_clean(self.send(field), remove_spaces_mode)) }
    end

    # Method content for sanitize_tiny_mce_X callbacks
    # @api private
    # @return [Proc]
    def tiny_mce_sanitization field, admin_mode, remove_spaces_mode
      Proc.new { self.send("#{field}=", Sanitization.sanitize_tiny_mce(self.send(field), admin_mode, remove_spaces_mode)) }
    end

    # Sanitization specifically for tiny mce fields which allow certain HTML elements
    #
    # @api private
    # @param field [String] The content to sanitize
    # @param admin_mode [Boolean] When true more tags are allowed
    # @return [String] The sanitized content
    def self.sanitize_tiny_mce field, admin_mode = false, remove_spaces = false
      modify Sanitize.clean(
        field,
        elements: admin_mode ?
          %w(a b i strong em p h1 h2 h3 h4 h5 h6 br hr ul ol li img div span iframe) :
          %w(b i strong em p h1 h2 h3 h4 h5 h6 br hr ul ol li),
        attributes: {
          'a' => ['href', 'type', 'target'],
          'img' => ['src', 'alt'],
          'iframe' =>  # iframes aren't allowed for non-admins
            ['src', 'frameborder', 'webkitallowfullscreen', 'mozallowfullscreen',
            'allowfullscreen'],
          :all => admin_mode ?
            ['width', 'height', 'data', 'name', 'id', 'class', 'style', 'data-truncate'] :
            ['width', 'height', 'name']
        },
        :css => {
          :properties => admin_mode ?
            ['text-align', 'margin', 'margin-top', 'margin-bottom', 'margin-left', 'margin-right', 'tab-stops',  'font-family', 'font-size', 'line-height', 'padding', 'padding-top', 'padding-bottom', 'padding-left', 'padding-right', 'cursor', 'height', 'width', 'font-variant', 'font-style', 'color', 'font-weight', 'text-decoration'] :
            []
        },
        protocols: {
          'a' => { 'href' => ['http', 'https', 'mailto', :relative] },
          'img' => { 'src' => ['http', 'https', :relative] }
        }
      ), remove_spaces
    end

    # Clean sanitization with further string modification
    #
    # @api private
    # @param field [String] The content to sanitize
    # @param remove_spaces [Boolean] for stricter modification
    # @return [String] The sanitized content
    def self.sanitize_clean field, remove_spaces
      # Needed because of the inject_questionnaire method in the mass_upload model (else statement)
      field = field.first if field.class == Array
      field = Sanitize.clean(field) if field
      reverse_encoding modify field, remove_spaces
    end

    # Modify sanitized strings even further
    # @api private
    # @param string [String, nil] The string to modify
    # @return [String] The modified string
    def self.modify string, remove_spaces
      if string.is_a? String
        string.
          strip(). # Remove leading and trailing white space
          gsub(
            /\s+/, (remove_spaces ? '' : ' ') # Either multiple whitespaces become one, or all whitespaces are removed
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
