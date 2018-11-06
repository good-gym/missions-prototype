class Dashboards::Coordinator::ReferralsController < Dashboards::Coordinator::BaseController
  def approve
    referral = Referral.find(params[:id])
    result = Referral::Approve.call(referral, approver: current_user)
    redirect_to root_path, notice: result.notice
  end

  def reject
    referral = Referral.find(params[:id])
    result = Referral::Reject.call(referral, rejection_params)
    redirect_to root_path, notice: result.notice
  end

  private

  def rejection_params
    params.require(:referral)
      .permit(:rejection_note)
      .merge(rejector: current_user)
  end
end
