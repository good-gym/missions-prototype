class RunnersController < ApplicationController
  def index
    @runners = Runner.all
  end

  def show
    @runner = Runner.find(params[:id])
  end

  def new
    @runner = Runner.new(default_radius: 5)
  end

  def create
    @runner = Runner.new(runner_params)
    if @runner.save
      session[:current_user_id] = @runner.cache_key
      redirect_to root_path
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
