# encoding: utf-8

class ResqueTest
  @queue = :resque_test

  def self.perform
    p 'resque test'
  end
  
end