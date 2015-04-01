require 'rails_helper'

RSpec.describe User, type: :model do
  before :each do
    @user = FactoryGirl.build :user
    @user.password_confirmation = @user.password
    @user.save
  end

  after :each do
    @user.destroy
  end

  it 'return active value of user' do
    @user.active = false
    expect(@user.active?).to be false
  end

  it 'set active to be true' do
    expect {@user.activate! }.to change { @user.active }.to(true)
  end
  describe 'deliver_password_reset instruction' do
    it 'should send new email' do
      expect {@user.deliver_password_reset_instructions!}.to change {ActionMailer::Base.deliveries.count}.to(1)
    end
  end
end
