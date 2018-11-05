class ListingsController < ApplicationController
  helper_method :postcode, :radius

  def index
    @referrals_by_day = Referral
      .approved
      .where.not(id: Referral.scheduled)
      .near(postcode, radius)
      .grouped_by_date

    @nearby_referrals = Referral
      .approved
      .where.not(id: Referral.scheduled)
      .near(postcode, radius * 2)
      .count("*")
  end

  private

  def radius
    params[:radius]&.to_i || 5
  end

  def postcode
    Postcode.postcode!(params[:postcode]) || current_user.alerts.first&.postcode
  end
end
