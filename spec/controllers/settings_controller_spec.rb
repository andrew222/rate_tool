require 'rails_helper'

RSpec.describe SettingsController, type: :controller do
  it 'redirect to login page' do
    get :index
    expect(response).to redirect_to("/login")
  end
end
