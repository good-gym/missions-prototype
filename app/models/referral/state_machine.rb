class Referral::StateMachine
  include Statesman::Machine

  state :pending, initial: true
  state :rejected
  state :approved
  state :confirmed
  state :cancelled

  transition from: :pending, to: %i[approved rejected]
  transition from: :approved, to: %i[confirmed rejected]
end
