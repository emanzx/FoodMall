class OffdaysController < ApplicationController
  before_action :set_offday, only: [:show, :edit, :update, :destroy]

  # GET /offdays
  # GET /offdays.json
  def index
    @search = Offday.ransack(params[:q])
    @search.sorts = 'date_off asc' if @search.sorts.empty?
    @offdays = @search.result.paginate(:per_page => 15, :page => params[:page])
  end

  # GET /offdays/1
  # GET /offdays/1.json
  def show
  end

  # GET /offdays/new
  def new
    @offday = Offday.new
  end

  # GET /offdays/1/edit
  def edit
  end

  # POST /offdays
  # POST /offdays.json
  def create
    @offday = Offday.new(offday_params)

    respond_to do |format|
      if @offday.save
        format.html { redirect_to offdays_url, notice: 'Offday was successfully created.' }
        format.json { render :show, status: :created, location: @offday }
      else
        format.html { render :new }
        format.json { render json: @offday.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /offdays/1
  # PATCH/PUT /offdays/1.json
  def update
    respond_to do |format|
      if @offday.update(offday_params)
        format.html { redirect_to @offday, notice: 'Offday was successfully updated.' }
        format.json { render :show, status: :ok, location: @offday }
      else
        format.html { render :edit }
        format.json { render json: @offday.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /offdays/1
  # DELETE /offdays/1.json
  def destroy
    @offday.destroy
    respond_to do |format|
      format.html { redirect_to offdays_url, notice: 'Offday was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_offday
      @offday = Offday.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def offday_params
      params.require(:offday).permit(:date_off, :note)
    end
end
