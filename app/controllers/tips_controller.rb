class TipsController < ApplicationController
  def index
    tips_obj = {}
    tips_category = TipCategory.where({category_type: params[:type], lang: params[:lang]}).first
    unless tips_category.blank?
      tips = tips_category.tips.exclude_tip_fields
      tips_obj = {title: tips_category.title, tips: tips}
    end
    render json: tips_obj, status: :ok
  end
end
