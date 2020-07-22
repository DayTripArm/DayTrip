class HeroesController < ApplicationController
  def index
    heroes = Hero.all()
    render json: heroes, status: :ok
  end
end
