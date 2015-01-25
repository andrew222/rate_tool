class Notifier < ActionMailer::Base
  default from: "andrew@webspider.com"

  def exchange_notifier_mail(rate)
    @rate = rate
    mail(to: "andrew@ekohe.com", subject: "please exchange!")
  end
end
