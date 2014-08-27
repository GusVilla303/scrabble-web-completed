class PlaysController < ApplicationController
  def index
    @plays = Play.all
  end

  def new
    @play = Play.new
  end

  def create
    @play = Play.new(play_params)

    if @play.save
      redirect_to plays_path
    else
      render :new
    end
  end

  def destroy
    @play = Play.find(params[:id])
    @play.destroy

    redirect_to plays_path
  end


  private
  def play_params
    params.require(:play).permit(:word)
  end
end
