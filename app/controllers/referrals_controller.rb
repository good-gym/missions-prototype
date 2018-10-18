class ReferralsController < ApplicationController
  helper_method :stage

  def new
    @referral = Referral.new(default_referral_params)
    @dates = params[:dates].map { |d| Date.parse(d) } if params[:dates]
    @matches = setup_matches

    params[:times]
      &.sort
      &.each { |d| @referral.time_slots.build(started_at: Time.parse(d)) }
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
    elsif params[:started_at] == "on"
      :date
    elsif params.key?(:referral)
      :when
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

  def setup_matches
    if @dates.present?
      Availability::Match.near(@referral.postcode, Availability.on_days(@dates))
    elsif @referral.time_slots.any?
      times = @referral.time_slots.map(&:started_at)
      Availability::Match.near(@referral.postcode, Availability.starting_at(times))
    else
      Availability::Match.near(@referral.postcode)
    end
  end
end
