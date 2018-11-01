class ReferralsController < ApplicationController
  helper_method :stage

  def index
    @referrals = current_user.referrals
  end

  def new
    @referral = Referral.new(default_referral_params)
    @dates = params[:dates].map { |d| Date.parse(d) } if params[:dates]
    @matches = setup_matches
    @result = Alert::Finder.near(@referral.postcode)
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
    if @referral.time_slots.any?
      :task
    elsif params[:when]
      :calendar
    elsif params.key?(:referral)
      :when
    else
      :first
    end
  end

  def default_referral_params
    if params.key?(:referral)
      data = referral_params
      data[:coach_attributes] = Coach.fake.attributes
        .merge(data[:coach_attributes] || {})
        .merge(postcode: referral_params[:postcode_str])
      data[:task_notes] ||= Faker::Lorem.sentence
      data[:risk] ||= :unknown
      data
    else
      { postcode: Postcode.new, coach: Coach.fake }
    end
  end

  def referral_params
    params.require(:referral)
      .permit(
        :postcode_str,
        coach_attributes: %i[name title],
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
