# https://github.com/rcode5/shoulda-matchers/blob/b5028c13b580fddc5ba2b79c8c4d0fbf86e78fcd/lib/shoulda/matchers/active_model/validate_presence_of_matcher.rb
#


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