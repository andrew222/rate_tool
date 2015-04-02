require "rails_helper"

RSpec.describe Notifier, type: :mailer do
  before :each do
    @user = FactoryGirl.build :user
    @user.password_confirmation = @user.password
    @rate = FactoryGirl.create :rate
    @user.save
  end

  after :each do
    @user.destroy
    @rate.destroy
  end

  describe 'exchange notifier mail' do
    it "renders the subject" do
      mail = Notifier.exchange_notifier_mail(@rate)
      expect(mail.subject).to eq("please exchange!")
    end
    it "send to andrew@ekohe.com" do
      mail = Notifier.exchange_notifier_mail(@rate)
      expect(mail.to).to eq(["andrew@ekohe.com"])
    end
    it "send from noreply@ratetool.com" do
      mail = Notifier.exchange_notifier_mail(@rate)
      expect(mail.from).to eq(["noreply@ratetool.com"])
    end
  end
end
