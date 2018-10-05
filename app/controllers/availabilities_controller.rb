class AvailabilitiesController < ApplicationController
  helper_method :stage

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

  private

  def stage
    if params.key?(:times)
      :confirm
    elsif params.key?(:dates)
      :time
    elsif params.key?(:availability)
      :date
    else
      :first
    end
  end

  def default_availability_params
    return availability_params if params.key?(:availability)

    { postcode: Postcode.new, radius: 10 }
  end

  def availability_params
    params.require(:availability)
      .permit(
        :radius,
        postcode_attributes: %i[postcode],
        time_slots_attributes: %i[started_at]
      )
      .merge(owner: current_user)
  end
end
