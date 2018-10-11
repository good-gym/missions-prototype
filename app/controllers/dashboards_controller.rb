class DashboardsController < ApplicationController
  def referrer
    @referrals = current_user.referrals
  end

  def runner
    redirect_to(root_path) unless current_user.is_a?(Runner)
  end

  def map
  end

  private

end
