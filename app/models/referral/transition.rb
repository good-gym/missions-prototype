class Referral::Transition < ApplicationRecord
  belongs_to :referral, inverse_of: :referral_transitions
  belongs_to :transitioner, polymorphic: true, optional: true

  after_destroy :update_most_recent, if: :most_recent?
  before_save :set_transitioner, on: :create

  private

  def set_transitioner
    return unless metadata["transitioner_id"] && metadata["transitioner_type"]

    self.transitioner_id = metadata["transitioner_id"]
    self.transitioner_type = metadata["transitioner_type"]
  end

  def update_most_recent
    last_transition = referral.referral_transitions.order(:sort_key).last
    return unless last_transition.present?

    last_transition.update_column(:most_recent, true)
  end
end
