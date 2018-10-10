class ReferralsController < ApplicationController
  helper_method :stage

  def new
    @referral = Referral.new(default_referral_params)
    @dates = params[:dates].map { |d| Date.parse(d) } if params[:dates]
    @times = params[:times].map { |t| Time.parse(t) } if params[:times]
  end

  private

  def stage
    if params.key?(:times)
      :task
    elsif params.key?(:dates)
      :time
    elsif params.key?(:referral)
      :date
    else
      :first
    end
  end

  def default_referral_params
    return referral_params if params.key?(:referral)

    { postcode: Postcode.new, urgent: false }
  end

  def referral_params
    params.require(:referral)
      .permit(
        :postcode_str, :urgent,
        time_slots_attributes: %i[started_at]
      )
      .merge(referrer: current_user)
  end
end
