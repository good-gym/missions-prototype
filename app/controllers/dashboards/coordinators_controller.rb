class Dashboards::CoordinatorsController < ApplicationController
  def show
    @pending_referrals = Referral.pending
  end
end
