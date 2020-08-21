class CalendarSettingsController < ApplicationController
  def edit
    if params[:id]
      begin
        cal_setting = CalendarSetting.where(driver_id: params[:id]).first
        render json: cal_setting, status: :ok
      rescue StandardError => e
        render json: e.message, status: :ok
      end
    end
  end

  def update
    if params[:id]
      begin
        cal_setting = CalendarSetting.find_by(driver_id: params[:id])
        cal_setting.update_attributes(params[:calendar_setting])
        cal_setting.save!
        render json: { message: "Setting saved" }, status: :ok
      rescue StandardError => e
        render json: e.message, status: :ok
      end
    end
  end
end
