class User < ActiveRecord::Base
  has_many :settings
  acts_as_authentic
  
  def active?
    self.active
  end

  def activate!
    self.active = true
    self.save
  end

  def deliver_password_reset_instructions!
    self.reset_perishable_token!
    Notifier.deliver_password_reset_instructions(self).deliver
  end
  
  def deliver_activation_instructions!
    reset_perishable_token!
    Notifier.deliver_activation_instructions(self).deliver
  end
  def deliver_activation_confirmation!
    Notifier.deliver_activation_confirmation(self).deliver
  end
end
