class CoordinatorsController < ApplicationController
  def index
    @coordinators = Coordinator.all
  end

  def show
    @coordinator = Coordinator.find(params[:id])
  end

  def new
    @coordinator = Coordinator.new
  end

  def create
    @coordinator = Coordinator.new(coordinator_params)
    if @coordinator.save
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def coordinator_params
    params.require(:coordinator).permit(:name)
  end
end
