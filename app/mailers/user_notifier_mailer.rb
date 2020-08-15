class UserNotifierMailer < ApplicationMailer
  def notify_admins(user, car_details)
    @user = user
    @car_details  = car_details
    AdminUser.all.each do |admin|
        mail(from: @user.email, to: admin.email,  subject: "The driver #{@user.name} has changed car details")
    end
  end
end
