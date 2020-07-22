class HitTheRoadsController < ApplicationController
  def index
    hit_the_road = HitTheRoad.all()
    render json: hit_the_road, status: :ok
  end
end
