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
        cal_setting = find_settings(cal_settings_params[:driver_id])
        unless cal_setting.blank?
          unless params[:day].blank?
            unavailable_days = cal_setting.unavailable_days.to_h
            unavailable_days = {excluded_days: []} if unavailable_days.blank?
            if unavailable_days["excluded_days"].include?(params[:day])
              unavailable_days["excluded_days"].delete(params[:day])
            else
              unavailable_days["excluded_days"] << params[:day]
            end
            params[:unavailable_days] = unavailable_days
            cal_settings_params[:unavailable_days] = unavailable_days
            params.delete(:day)
          end
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
    params.except(:calendar_setting,:id).permit( :advance_notice, :availability_window, :day, :driver_id, unavailable_days: {})
  end

  def find_settings driver_id
    CalendarSetting.where(driver_id: driver_id).first
  end
end
