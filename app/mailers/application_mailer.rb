class ApplicationMailer < ActionMailer::Base
  default from: ENV['DTArmenia_EMAIL']
  layout 'mailer'
end
