class SetdefaultsController < ApplicationController
  before_action :set_setdefault, only: [:show, :edit, :update, :destroy]

  # GET /setdefaults
  # GET /setdefaults.json
  def index
    unless current_user.role.eql?('admin')
      flash[:danger] = "You don't have access to that Page!"
      redirect_to '/'
      return
    end
    
    @setdefaults = Setdefault.all
  end

  # GET /setdefaults/1
  # GET /setdefaults/1.json
  def show
  end

  # GET /setdefaults/new
  def new
    @cust = User.find(params[:cust_id])
    @users = User.all
    @setdefault = Setdefault.new
  end

  # GET /setdefaults/1/edit
  def edit
    @cust = User.find(params[:cust_id])
    @users = User.all
  end

  # POST /setdefaults
  # POST /setdefaults.json
  def create
    @setdefault = Setdefault.new(setdefault_params)

    respond_to do |format|
      if @setdefault.save
        flash[:success] = 'Default was successfully created.'
        format.html { redirect_to '/' }
        format.json { render :show, status: :created, location: @setdefault }
      else
        format.html { render :new }
        format.json { render json: @setdefault.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /setdefaults/1
  # PATCH/PUT /setdefaults/1.json
  def update
    respond_to do |format|
      if @setdefault.update(setdefault_params)
        flash[:success] = 'Default was successfully updated.'
        format.html { redirect_to '/' }
        format.json { render :show, status: :ok, location: @setdefault }
      else
        format.html { render :edit }
        format.json { render json: @setdefault.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /setdefaults/1
  # DELETE /setdefaults/1.json
  def destroy
    @setdefault.destroy
    respond_to do |format|
      flash[:success] = 'Default was successfully destroyed.'
      format.html { redirect_to setdefaults_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_setdefault
      @setdefault = Setdefault.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def setdefault_params
      params.require(:setdefault).permit(:chef, :runner, :user_id)
    end
end
