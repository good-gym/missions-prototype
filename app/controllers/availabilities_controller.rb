class AvailabilitiesController < ApplicationController
  helper_method :stage, :date

  before_action :redirect_to_settings_if_necessary?, only: :new

  def new
    @availability = Availability.new(default_availability_params)
    @dates = params[:dates].map { |d| Date.parse(d) } if params[:dates]
    if params[:times]
      params[:times].each { |d| @availability.time_slots.build(started_at: Time.parse(d)) }
    end
  end

  def create
    @availability = Availability.new(default_availability_params)
    if @availability.save
      redirect_to root_path
    else
      @dates = params[:dates].map { |d| Date.parse(d) } if params[:dates]
      @times = params[:times].map { |d| Time.parse(d) } if params[:times]

      render :new
    end
  end

  def destroy
    @availability = Availability.find(params[:id])

    message =
      if @availability.runner == current_user && @availability.destroy
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

  def default_availability_params
    return availability_params if params.key?(:availability)

    { postcode: current_user.postcode, radius: 5,
      preferences: current_user.preferences }
  end

  def availability_params
    params.require(:availability)
      .permit(
        :postcode_str, :radius,
        time_slots_attributes: %i[started_at]
      )
      .merge(runner: current_user)
  end
end
