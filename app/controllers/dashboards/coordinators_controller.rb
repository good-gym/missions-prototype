class Dashboards::CoordinatorsController < ApplicationController
  def show
    @states = Referral.states
    @state = params[:state].present? ? params[:state].to_sym : :all
    @referrals = @states[@state]
  end
end
