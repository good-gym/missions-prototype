class ReservationsController < ApplicationController
  def index
    @reservations = current_user.reservations
  end

  def show
    @reservation = current_user.reservations.find(params[:id])
  end

  def new
    @reservation = current_user.reservations.new(reservation_params)
    @referral = @reservation.referral
  end

  def create
    @reservation = Reservation.new(reservation_params)
    if @reservation.save
      redirect_to @reservation
    else
      render :new
    end
  end

  private

  def reservation_params
    params
      .require(:reservation)
      .permit(:referral_id, time_slot_ids: [])
      .merge(runner: current_user)
  end
end
