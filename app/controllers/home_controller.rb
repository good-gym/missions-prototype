class HomeController < ApplicationController
  def index
    return redirect_to dashboards_runner_path if current_user.is_a?(Runner)
    return redirect_to dashboards_referrer_path if current_user.is_a?(Referrer)
    return redirect_to dashboards_coordinator_path if current_user.is_a?(Coordinator)

    @runners = Runner.all
    @referrers = Referrer.all
    @coordinators = Coordinator.all
  end
end
