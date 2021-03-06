class UserNotifierMailer < ApplicationMailer
  default from: ENV['DTArmenia_EMAIL']

  def notify_admins_car_details(login_id)
    @user = Profile.user_basic_info(login_id)
    AdminUser.all.each do |admin|
        mail(from: @user.email, to: admin.email,  subject: "DayTrip Armenia: Driver’s Account Changes")
    end
  end

  def notify_admins_prereg(login_id)
    @user = Profile.user_basic_info(login_id)
    AdminUser.all.each do |admin|
      mail(from: @user.email, to: admin.email,  subject: "DayTrip Armenia: New Driver")
    end
  end

  def notify_drivers_prereg(login_id)
    @user = Profile.user_basic_info(login_id)
    mail(to: @user.email, subject: 'DayTrip Armenia: Account Registration')
  end

  # def notify_travelers_prereg(login_id)
  #   @user = Profile.user_basic_info(login_id)
  #   mail(to: @user.email, subject: 'DayTrip Armenia: Account Verification')
  # end

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

  def notify_drivers_suspend_approval(login_id)
    @user = Profile.user_basic_info(login_id)
    mail(to: @user.email, subject: 'DayTrip Armenia: Account Changes Approved')
  end

  def notify_drivers_suspend_rejection(login_id)
    @user = Profile.user_basic_info(login_id)
    mail(to: @user.email, subject: 'DayTrip Armenia: Account Changes Rejected')
  end

end
