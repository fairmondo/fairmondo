module Article::State
  extend ActiveSupport::Concern

  included do
    # market place state
    attr_protected :state, :active

    state_machine :initial => :preview do

      state :preview do
        def active
          false
        end
      end

      state :active do
        def active
          true
        end
      end

      state :locked do
        def active
          false
        end
      end

      event :activate do
        transition [:preview,:locked] => :active
      end

      event :deactivate do
        transition :active => :locked
      end

      after_transition :on => :activate, :do => :calculate_fees_and_donations

    end

  end

end