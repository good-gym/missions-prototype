module Referral::HasStateMachine
  extend ActiveSupport::Concern

  included do
    include Statesman::Adapters::ActiveRecordQueries
    has_many :referral_transitions,
             autosave: false, class_name: "Referral::Transition"

    def self.transition_class
      Referral::Transition
    end
    private_class_method :transition_class

    def self.initial_state
      :pending
    end
    private_class_method :initial_state

    delegate :can_transition_to?, :transition_to!, :transition_to, :current_state,
         to: :state_machine
  end

  def approved?
    state_machine.in_state?(:approved)
  end

  def cancelled?
    state_machine.in_state?(:cancelled)
  end

  def state_machine
    @state_machine ||= Referral::StateMachine.new(
      self, transition_class: Referral::Transition
    )
  end
end
