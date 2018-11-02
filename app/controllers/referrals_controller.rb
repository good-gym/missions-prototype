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
      {
        task_notes: Faker::Lorem.sentence,
        coach_attributes: Coach.fake.attributes.merge(
          postcode: referral_params[:postcode_str]
        )
      }.merge(time_slots_params)
        .with_indifferent_access
        .deep_merge(referral_params)
    else
      {
        postcode: Postcode.new, coach: Coach.fake,
        duration: 60, volunteers_needed: 2
      }
    end
  end

  def time_slots_params
    return {} unless params[:times]

    times = params[:times].map do |t|
      { started_at: Time.at(t.to_i) }
    end
    { time_slots_attributes: times }
  end

  def referral_params
    params.require(:referral)
      .permit(
        :postcode_str, :duration, :volunteers_needed,
        preferences: {},
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
