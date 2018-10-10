class ReferrersController < ApplicationController
  def index
    @referrers = Referrer.all
  end

  def show
    @referrer = Referrer.find(params[:id])
  end

  def new
    @referrer = Referrer.new
  end

  def create
    @referrer = Referrer.new(referrer_params)
    if @referrer.save
      redirect_to referrers_path
    else
      render :new
    end
  end

  private

  def referrer_params
    params.require(:referrer).permit(:name)
  end
end
