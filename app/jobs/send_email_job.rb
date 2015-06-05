# encoding: utf-8

class SendEmailJob
  include Sidekiq::Worker

  def perform(user_id, method)
    @user = User.find(user_id)
    @user.send(method.to_sym)
  end
end
