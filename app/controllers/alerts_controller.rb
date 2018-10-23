class AlertsController < ApplicationController
  helper_method :stage, :date

  before_action :redirect_to_settings_if_necessary?, only: :new

  def new
    @alert = Alert.new(default_alert_params)
    @dates = params[:dates].map { |d| Date.parse(d) } if params[:dates]
    if params[:times]
      params[:times].each { |d| @alert.time_slots.build(started_at: Time.parse(d)) }
    end
  end

  def create
    @alert = Alert.new(default_alert_params)
    if @alert.save
      redirect_to root_path
    else
      @dates = params[:dates].map { |d| Date.parse(d) } if params[:dates]
      @times = params[:times].map { |d| Time.parse(d) } if params[:times]

      render :new
    end
  end

  def destroy
    @alert = Alert.find(params[:id])

    message =
      if @alert.runner == current_user && @alert.destroy
        "Cancelled mission booking"
      else
        "Unable to cancel mission booking"
      end

    redirect_back(fallback_location: root_path, notice: message)
  end

  private

  def date
    @date ||= params.has_key?(:date) ? Date.parse(params[:date]) : Date.today
  end

  def stage
    if params.key?(:times)
      :confirm
    elsif params.key?(:dates)
      :time
    else
      :date
    end
  end

  def default_alert_params
    return alert_params if params.key?(:alert)

    { postcode: current_user.postcode, radius: 5,
      preferences: current_user.preferences }
  end

  def alert_params
    params.require(:alert)
      .permit(
        :postcode_str, :radius,
        time_slots_attributes: %i[started_at]
      )
      .merge(runner: current_user)
  end
end
