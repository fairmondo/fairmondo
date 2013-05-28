module Fairtastic
  module Helpers
    module InputHelper

      include Formtastic::Helpers::InputHelper

      def input(method, options = {})

        @input_step_with_errors ||= has_errors? method,options #set for input_step blocks

        super

      end

    end
  end
end
