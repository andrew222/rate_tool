# encoding: utf-8

class SendEmailJob
  @queue = :send_email_job

  def self.perform(user_id, method)
    @user = User.find(user_id)
    @user.send(method.to_sym)
  end
end
