class UserNotifierMailer < ApplicationMailer
  def notify_admins_car_details(login_id)
    @user = Profile.user_basic_info(login_id)
    AdminUser.all.each do |admin|
        mail(from: @user.email, to: admin.email,  subject: "Car details of driver has been updated")
    end
  end

  def notify_admins_prereg(login_id)
    @user = Profile.user_basic_info(login_id)
    AdminUser.all.each do |admin|
      mail(from: @user.email, to: admin.email,  subject: "Registration completed")
    end
  end
end
