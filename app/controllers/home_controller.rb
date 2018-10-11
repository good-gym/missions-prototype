class HomeController < ApplicationController
  def index
    return redirect_to runner_dashboards_path if current_user.is_a?(Runner)
    return redirect_to dashboards_referrer_path if current_user.is_a?(Referrer)

    @runners = Runner.all
    @referrers = Referrer.all
  end
end
