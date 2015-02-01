class User < ActiveRecord::Base
  has_many :settings
  acts_as_authentic
end
