class HomeController < ApplicationController
  def heroes
    heroes = Hero.where(published: true).first
    render json: heroes, status: :ok
  end

  def hit_the_road
    hit_the_road = HitTheRoad.where(published: true).first
    render json: hit_the_road, status: :ok
  end
end
