class Dashboards::ReferrersController < ApplicationController
  before_action :verify_admin
  helper_method :postcode

  def show
    @referrals = current_user.referrals
  end

  def map
    if postcode.present?
      @available_slots = Availability::Match.near(postcode)
      @available_alerts = Alert::Finder.near(postcode)
    else
      @available_slots = Availability::Match.all
      @available_alerts = Alert::Finder.near(
        Postcode.located.order("random()").first
      )
    end
  end

  private

  def postcode
    return if params[:postcode].blank?

    str = UKPostcode.parse(params[:postcode]).to_s
    @postcode ||= Postcode.find_or_create_by(postcode: str)
  end

  def verify_admin
    return if current_user&.is_a?(Referrer)

    redirect_to root_url, notice: "You're not authorised to do this."
  end
end
