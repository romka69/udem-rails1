class ApplicationMailer < ActionMailer::Base
  default from: 'support@udem-rails.herokuapp.com'
  layout 'mailer'
end
