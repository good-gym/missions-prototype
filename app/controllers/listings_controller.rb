class ListingsController < ApplicationController
  helper_method :postcode, :radius

  before_action :redirect_to_settings_if_necessary?, only: :index

  def index
    @days = Array.new(14) { |d| Date.today + d.days }
    @referrals = Referral.near(postcode, radius)
  end

  private

  def radius
    params[:radius] || 5
  end

  def postcode
    Postcode.postcode!(params[:postcode]) || current_user.postcode
  end
end
