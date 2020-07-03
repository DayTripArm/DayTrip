class TipsController < ApplicationController
  def index
    tips = TipCategory.exclude_fields.tip_title_alias
                      .joins(:tips).where(category_type: params[:type])
    render json: {tips: tips}, status: :ok
  end
end
