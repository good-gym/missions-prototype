class Dashboards::Coordinator::ReferralsController < Dashboards::Coordinator::BaseController
  def approve
    referral = Referral.find(params[:id])
    result = Referral::Approve.call(referral, approver: current_user)
    redirect_to root_path, notice: result.notice
  end
end
