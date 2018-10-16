class RunnersController < ApplicationController
  def index
    @runners = Runner.all
  end

  def show
    @runner = Runner.find(params[:id])
  end

  def new
    @runner = Runner.new
  end

  def create
    @runner = Runner.new(runner_params)
    if @runner.save
      redirect_to runner_path(@runner)
    else
      render :new
    end
  end

  private

  def runner_params
    params.require(:runner)
      .permit(:name, :postcode_str, :default_radius, preferences: {})
  end
end
