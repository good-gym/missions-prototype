class Dashboards::ReferrersController < ApplicationController
  def show
    @referrals = current_user.referrals
  end

  def map
    @available_slots = Availability::Match.all
  end
end
