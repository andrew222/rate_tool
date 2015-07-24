class RatesController < ApplicationController
  before_action :set_rate, only: [:show, :edit, :update, :destroy]

  # GET /rates
  # GET /rates.json
  def index
    @rates = SpdbRate.paginate(:page => params[:page]).order("id desc")
    @rate_date_arr = SpdbRate.all_rates
  end

  # GET /rates/1
  # GET /rates/1.json
  def show
  end

  # GET /rates/new
  def new
    @rate = Rate.new
  end

  # GET /rates/1/edit
  def edit
  end

  # POST /rates
  # POST /rates.json
  def create
    @rate = Rate.new(rate_params)

    respond_to do |format|
      if @rate.save
        format.html { redirect_to @rate, notice: 'Rate was successfully created.' }
        format.json { render :show, status: :created, location: @rate }
      else
        format.html { render :new }
        format.json { render json: @rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rates/1
  # PATCH/PUT /rates/1.json
  def update
    respond_to do |format|
      if @rate.update(rate_params)
        format.html { redirect_to @rate, notice: 'Rate was successfully updated.' }
        format.json { render :show, status: :ok, location: @rate }
      else
        format.html { render :edit }
        format.json { render json: @rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rates/1
  # DELETE /rates/1.json
  def destroy
    @rate.destroy
    respond_to do |format|
      format.html { redirect_to rates_url, notice: 'Rate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def search
    start_time_str = params[:start_time]
    end_time_str = params[:end_time]
    respond_to do |format|
      if start_time_str.blank? || end_time_str.blank?
	format.js {render nothing: true}
      else
	start_time = Time.zone.parse(start_time_str)
	end_time = Time.zone.parse(end_time_str)
	@rates = SpdbRate.where(published_at: (start_time..end_time)).order("published_at desc")
	format.js
      end
    end
  end
  def export
    time = Time.zone.now

    time_str = time.strftime("%Y%m%d")
    file_name = "rates_#{time_str}.xls"
    @rates = SpdbRate.where(created_at:  (time.beginning_of_day..time.end_of_day))
    respond_to do |format|
      format.xls {format.xls { headers["Content-Disposition"] = "attachment; filename=\"#{file_name}\""}}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rate
      @rate = Rate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rate_params
      params.require(:rate).permit(:type, :bid_fix)
    end
end
