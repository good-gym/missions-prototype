class ListingsController < ApplicationController
  helper_method :postcode, :radius

  def index
    @referrals_by_day = Referral
      .approved
      .near(postcode, radius)
      .grouped_by_date
  end

  private

  def radius
    params[:radius]&.to_i || 5
  end

  def postcode
    Postcode.postcode!(params[:postcode]) || current_user.alerts.first&.postcode
  end
end
