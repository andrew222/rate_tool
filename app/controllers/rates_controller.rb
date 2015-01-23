class RatesController < ApplicationController
  def index
    @rates = Rate.paginate(:page => params[:page]).order("created_at desc")
    respond_to do |format|
      format.html
    end
  end

  def edit
  end

  def new
  end

  def create
  end
end
