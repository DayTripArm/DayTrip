class TipsController < ApplicationController
  def index
    tips_category = TipCategory.where(category_type: params[:type]).first
    tips = tips_category.tips.exclude_tip_fields
    render json: {title: tips_category.title, tips: tips}, status: :ok
  end
end
