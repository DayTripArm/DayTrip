class CalendarSettingsController < ApplicationController
  def edit
    if params[:id]
      begin
        cal_setting = find_settings(params[:id]) || {}
        cal_setting[:advance_notice] = cal_setting[:advance_notice] || 0
        cal_setting[:availability_window] = cal_setting[:availability_window] || 4
        cal_setting[:available_days] = cal_setting[:available_days].nil? ? [] : cal_setting[:available_days]["included_days"]
        render json: cal_setting, status: :ok
      rescue StandardError => e
        render json: e.message, status: :ok
      end
    end
  end

  def create_update
      begin
        cal_setting = find_settings(cal_settings_params[:driver_id])
        unless cal_setting.blank?
          cal_setting.update_attributes(cal_settings_params)
          cal_setting.save
        else
          cal_setting = CalendarSetting.new
          cal_setting.assign_attributes(cal_settings_params)
          cal_setting.save
        end
        render json: { message: "Calendar settings has been changed" }, status: :ok
      rescue StandardError => e
        render json: e.message, status: :ok
      end
  end

  private
  def cal_settings_params
    params.except(:calendar_setting,:id).permit( :advance_notice, :availability_window, :driver_id, available_days: {included_days: []})
  end

  def find_settings driver_id
    CalendarSetting.where(driver_id: driver_id).first
  end
end
