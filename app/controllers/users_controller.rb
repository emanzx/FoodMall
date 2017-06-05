class UsersController < ApplicationController
  before_filter :authorize, except: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @match = params[:dd]
    @setdefault = Setdefault.all
    @users = User.all
    @setdefault.each do |f|
      if f.user_id == @user.id
        @find = f.user_id
        @setid = f.id
        @setrun = f.runner
        @setchef = f.chef
      end
    end
  end

  def all_customer
    unless current_user.role.eql?('admin')
      flash[:danger] = "You don't have access to that Page!"
      redirect_to '/'
      return
    end
    @search = User.where(role: 'customer').ransack(params[:q])
    @search.sorts = 'created_at desc' if @search.sorts.empty?
    @users = @search.result.paginate(:per_page => 15, :page => params[:page])
  end

  def all_user
    unless current_user.role.eql?('admin')
      flash[:danger] = "You don't have access to that Page!"
      redirect_to '/'
      return
    end
    @search = User.where(role: 'admin').ransack(params[:q])
    @search.sorts = 'created_at desc' if @search.sorts.empty?
    @user = @search.result.paginate(:per_page => 15, :page => params[:page])
  end

  def all_chef
    unless current_user.role.eql?('admin')
      flash[:danger] = "You don't have access to that Page!"
      redirect_to '/'
      return
    end
    @search = User.where(role: 'chef').ransack(params[:q])
    @search.sorts = 'created_at desc' if @search.sorts.empty?
    @chefs = @search.result.paginate(:per_page => 15, :page => params[:page])
  end

  def all_runner
    unless current_user.role.eql?('admin')
      flash[:danger] = "You don't have access to that Page!"
      redirect_to '/'
      return
    end
    @search = User.where(role: 'runner').ransack(params[:q])
    @search.sorts = 'created_at desc' if @search.sorts.empty?
    @runners = @search.result.paginate(:per_page => 15, :page => params[:page])
  end 

  def admin
    unless current_user.role.eql?('admin')
      flash[:danger] = "You don't have access to that Page!"
      redirect_to '/'
      return
    end
    @items = Item.count
    @orderitems = Orderitem.where(:status => "complete").count
    @cust = User.where(role: "customer").count
    @wait = Orderitem.count - @orderitems

  end

  def customer
    unless current_user.role.eql?('customer')
      flash[:danger] = "You don't have access to that Page!"
      redirect_to '/'
      return
    end
    @search = Item.ransack(params[:q])
    @search.sorts = 'name asc' if @search.sorts.empty?
    @items = @search.result.paginate(:per_page => 10, :page => params[:page])
    @orderitems = Orderitem.all
    @orderitems.each do |orderitem|
      if current_user == orderitem.user && orderitem.status == 'pre-order'
        @stat = "true"
      end
    end
  end

  def runner
    unless current_user.role.eql?('runner')
      flash[:danger] = "You don't have access to that Page!"
      redirect_to '/'
      return
    end
    @items = Item.all
    @orderitems = Orderitem.all
    @group = @orderitems.group_by { |t| t.totalprice }
  end

  def chef
    unless current_user.role.eql?('chef')
      flash[:danger] = "You don't have access to that Page!"
      redirect_to '/'
      return
    end
    @items = Item.all
    @orderitems = Orderitem.all
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    
  end

  def change_password
    @user = User.find(params[:id])
  end

  def update_password
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update(password_params)
        flash[:success] = 'Password was successfully updated.'
        format.html { redirect_to @user }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :change_password }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        flash[:success] = 'User was successfully created.'
        format.html { redirect_to new_user_path }
        format.json { render :show, status: :created, location: @user }
      else
        #flash[:danger] = 'There was a problem create the user.'
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        flash[:success] = 'User was successfully updated.'
        format.html { redirect_to @user }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    role = @user.role
    if current_user.admin == true
      @user.destroy
      respond_to do |format|
        flash[:success] = 'User was successfully destroyed.'
        if role == "customer"
          format.html { redirect_to '/all_customer' }
          format.json { head :no_content }
        elsif role == "chef"
          format.html { redirect_to '/all_chef' }
          format.json { head :no_content }
        elsif role == "runner"
          format.html { redirect_to '/all_runner' }
          format.json { head :no_content }
        else
          format.html { redirect_to '/' }
          format.json { head :no_content }
        end
      end
    else
      if @user.admin == true
        redirect_to '/admin_list'
      else
        @user.destroy
        respond_to do |format|
          flash[:success] = 'User was successfully destroyed.'
          if role == "customer"
            format.html { redirect_to '/all_customer' }
            format.json { head :no_content }
          elsif role == "chef"
            format.html { redirect_to '/all_chef' }
            format.json { head :no_content }
          elsif role == "runner"
            format.html { redirect_to '/all_runner' }
            format.json { head :no_content }
          else
            format.html { redirect_to '/' }
            format.json { head :no_content }
          end
        end
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:fullname, :username, :email, :role, :address, :password, :password_confirmation, :phone)
    end

    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end
end
