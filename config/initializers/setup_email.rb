ActionMailer::Base.smtp_settings = {
  :address              => "smtp.sendgrid.net",
  :port                 => 587,
  :domain               => "webspider.com",
  :user_name            => "andrew101",
  :password             => "Andrew123~",
  :authentication       => "plain",
  :enable_starttls_auto => true
}
