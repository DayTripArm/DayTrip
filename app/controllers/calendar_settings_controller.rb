class CalendarSettingsController < ApplicationController
  def edit
    if params[:id]
      begin
        cal_setting = find_settings(params[:id])
        render json: cal_setting || {}, status: :ok
      rescue StandardError => e
        render json: e.message, status: :ok
      end
    end
  end

  def create_update
      begin
        cal_setting = find_settings(params[:calendar_setting][:driver_id])
        unless cal_setting.blank?
          cal_setting.update_attributes(cal_settings_params)
          cal_setting.save
        else
          cal_setting = CalendarSetting.new
          cal_setting.assign_attributes(cal_settings_params)
          cal_setting.save
        end
        render json: { message: "Setting saved" }, status: :ok
      rescue StandardError => e
        render json: e.message, status: :ok
      end
  end

  private
  def cal_settings_params
    params.require(:calendar_setting).permit(:advance_notice, :availability_window, :driver_id)
  end

  def find_settings driver_id
    CalendarSetting.where(driver_id: driver_id).first
  end
end
