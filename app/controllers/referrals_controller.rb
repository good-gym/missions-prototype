class ReferralsController < ApplicationController
  helper_method :stage

  def new
    @referral = Referral.new(default_referral_params)
    @dates = params[:dates].map { |d| Date.parse(d) } if params[:dates]
    if params[:times]
      params[:times].sort.each { |d| @referral.time_slots.build(started_at: Time.parse(d)) }
    end
  end

  def create
    @referral = Referral.new(default_referral_params)
    if @referral.save
      redirect_to root_path
    else
      @dates = params[:dates].map { |d| Date.parse(d) } if params[:dates]
      @times = params[:times].map { |d| Time.parse(d) } if params[:times]

      render :new
    end
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
    if params.key?(:referral)
      data = referral_params
      data[:coach] ||= Coach.fake
      data[:task_notes] ||= Faker::Lorem.sentence
      data[:risk] ||= :unknown
      data
    else
      { postcode: Postcode.new, urgent: false }
    end
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
