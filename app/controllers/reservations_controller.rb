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
    @date = Date.parse(params[:date]) if params[:date].present?
  end

  def create
    @reservation = Reservation.new(reservation_params)
    if @reservation.save
      alert_referrer if @reservation.referral.scheduled?

      redirect_to @reservation
    else
      render :new
    end
  end

  def destroy
    @reservation = current_user.reservations.find(params[:id])
    if @reservation.destroy
      redirect_to(root_path, notice: "Cancelled mission")
    else
      flash[:notice] = "Unable to delete reservation"
      render :show
    end
  end

  private

  def reservation_params
    params
      .require(:reservation)
      .permit(:referral_id, time_slot_ids: [])
      .merge(runner: current_user)
  end

  def alert_referrer
    Email::Send.call(
      from: current_user,
      to: [@reservation.referral.referrer],
      object: @reservation.referral,
      subject: "Your referral has been scheduled",
      body: "Good news, runners have signed up to your referral"
    )
  end
end
