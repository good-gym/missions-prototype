class Referral::Approve
  include Service

  attr_reader :referral, :approver

  def initialize(referral, approver:)
    @referral = referral
    @approver = approver
  end

  def call
    if approve!
      alert_referrer
      alert_runners_in_range
      Success.new("Referral approved")
    else
      Failure.new("Unable to approve referral")
    end
  end

  private

  def approve!
    referral.state_machine.transition_to(
      :approved,
      transitioner_id: approver.id, transitioner_type: approver.class.name
    )
  end

  def alert_referrer
    Email::Send.call(
      from: approver,
      to: [referral.referrer],
      object: referral,
      subject: "Your referral has been approved",
      body: "Good news, your referral is going ahead"
    )
  end

  def alert_runners_in_range
    Email::Send.call(
      from: approver,
      to: Runner.all,
      object: referral,
      subject: "A referral is happening",
      body: "Here's a referral for you"
    )
  end
end
