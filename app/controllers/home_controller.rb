class HomeController < ApplicationController
  def heroes
    heroes = Hero.all()
    render json: heroes, status: :ok
  end

  def hit_the_road
    hit_the_road = HitTheRoad.all()
    render json: hit_the_road, status: :ok
  end
end
