require 'rails_helper'

RSpec.describe RatesController do
  render_views false
  it "responds successfully" do
    get :index
    expect(response.status).to eq(200)
  end
  it "renders the rates/index template" do
    get :index
    expect(response).to render_template("rates/index")
    expect(response.body).to eq("")
  end
end
