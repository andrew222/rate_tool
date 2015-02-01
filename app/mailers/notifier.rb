class Notifier < ActionMailer::Base
  default from: "andrew@ratetool.com"

  def exchange_notifier_mail(rate)
    @rate = rate
    mail(to: "andrew@ekohe.com", subject: "please exchange!")
  end

  def deliver_activation_instructions(user)
    @user = user
    mail(to: user.email, subject: t("shared.activation_instruction"))
  end

  def deliver_activation_confirmation(user)
    @user = user
    mail(to: user.email, subject: t("shared.activation_instruction_confirmation"))
  end
end
