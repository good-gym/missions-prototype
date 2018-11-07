class Referral::List
  include Service

  attr_reader :referral, :user

  def initialize(referral, user:)
    @referral = referral
    @user = user
  end

  def call
    if list!
      alert_referrer
      alert_runners
      Success.new("Referral listed")
    else
      Failure.new("Unable to list referral")
    end
  end

  private

  def list!
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

  def alert_runners_in_range
    Email::Send.call(
      from: user,
      to: Runner.all,
      object: referral,
      subject: "A referral is happening",
      body: "Here's a referral for you"
    )
  end
end
