class Dashboards::ReferrersController < ApplicationController
  helper_method :postcode

  def show
    @referrals = current_user.referrals
  end

  def map
    @available_slots =
      if postcode.present?
        Availability::Match.near(postcode)
      else
        Availability::Match.all
      end
  end

  private

  def postcode
    return if params[:postcode].blank?

    str = UKPostcode.parse(params[:postcode]).to_s
    @postcode ||= Postcode.find_or_create_by(postcode: str)
  end
end
