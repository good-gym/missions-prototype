class Referral::Reject
  include Service

  attr_reader :referral, :rejector, :rejection_note

  def initialize(referral, options = {})
    @referral = referral
    @rejector = options[:rejector]
    @rejection_note = options[:rejection_note]
  end

  def call
    if reject!
      alert_referrer
      Success.new("Referral rejected")
    else
      Failure.new("Unable to reject referral")
    end
  end

  private

  def reject!
    referral.state_machine.transition_to(
      :rejected,
      transitioner_id: rejector.id, transitioner_type: rejector.class.name
    )
  end

  def alert_referrer
    Email::Send.call(
      from: rejector,
      to: [referral.referrer],
      object: referral,
      subject: "Your referral has been rejected",
      body: "Unfortuantely your referral is not going ahead: #{rejection_note}"
    )
  end
end
