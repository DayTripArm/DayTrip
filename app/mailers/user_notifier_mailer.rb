class UserNotifierMailer < ApplicationMailer
  default from: ENV['DTArmenia_EMAIL']

  def notify_admins_car_details(login_id)
    @user = Profile.user_basic_info(login_id)
    AdminUser.all.each do |admin|
        mail(from: @user.email, to: admin.email,  subject: "DayTrip Armenia: Account Temporarily Suspended")
    end
  end

  def notify_admins_prereg(login_id)
    @user = Profile.user_basic_info(login_id)
    AdminUser.all.each do |admin|
      mail(from: @user.email, to: admin.email,  subject: "Registration completed")
    end
  end

  def notify_drivers_prereg(login_id)
    @user = Profile.user_basic_info(login_id)
    mail(to: @user.email, subject: 'DayTrip Armenia: Account Registration')
  end

  def notify_travelers_prereg(login_id)
    @user = Profile.user_basic_info(login_id)
    mail(to: @user.email, subject: 'DayTrip Armenia: Account Verification')
  end

  def notify_profile_approved(login_id)
    @user = Profile.user_basic_info(login_id)
    mail(to: @user.email, subject: 'DayTrip Armenia: Account Approval Notice')
  end

  def notify_profile_declined(login_id)
    @user = Profile.user_basic_info(login_id)
    mail(to: @user.email, subject: 'DayTrip Armenia: Account Rejection Notice')
  end

  def notify_drivers_suspend(login_id)
    @user = Profile.user_basic_info(login_id)
    mail(to: @user.email, subject: 'DayTrip Armenia: Account Temporarily Suspended')
  end
end
