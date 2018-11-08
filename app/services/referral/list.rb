class Referral::List
  include Service

  attr_reader :referral, :user, :mission

  def initialize(referral, user:)
    @referral = referral
    @user = user
  end

  def call
    return Failure.new("Referral not scheduled") unless referral.scheduled?

    if list!
      alert_referrer
      alert_runners
      Success.new("Referral listed")
    else
      Failure.new("Unable to list referral", object: mission)
    end
  end

  private

  def list!
    started_at = scheduled_time_slot.started_at
    @mission = Mission.create(started_at: started_at)
    referral.update(mission: @mission) if @mission.valid?
  end

  def scheduled_time_slot
    @scheduled_time_slot ||= referral.scheduled_time_slots.first
  end

  def alert_referrer
    Email::Send.call(
      from: user,
      to: [referral.referrer],
      object: referral,
      subject: "Your referral has been listed",
      body: "Good news, your referral is going ahead"
    )
  end

  def alert_runners
    Email::Send.call(
      from: user,
      to: Runner.all,
      object: referral,
      subject: "A referral is happening",
      body: "Here's a referral for you"
    )
  end
end
