# encoding: utf-8

class SendEmailJob
  @queue = :send_email_job

  def self.perform(method, obj)
   obj.send(method)
  end
end
