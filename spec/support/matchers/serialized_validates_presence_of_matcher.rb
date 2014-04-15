module Shoulda # :nodoc:
  module Matchers
    module ActiveModel # :nodoc:
      class ValidatePresenceOfMatcher < ValidationMatcher # :nodoc:
        def blank_value
          if collection? || serialized?
            []
          else
            nil
          end
        end
        def serialized?
          @subject.class.respond_to?(:serialized_attributes) &&
            @subject.class.serialized_attributes.keys.include?(@attribute.to_s)
        end
      end
    end
  end
end