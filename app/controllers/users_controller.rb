class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all.order('usort asc')
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    if params[:cros]!='y'
      #create from page query. @xieyinghua
      @user = User.new(user_params)
    else
      #create from cros post. @xieyinghua
      new_user_params=User.new
      new_user_params[:uid]=params[:uid]
      new_user_params[:upw]=params[:upw]
      new_user_params[:uanem]=params[:uname]
      new_user_params[:upower]=params[:upower]
      new_user_params[:uphone]=params[:uphone]
      new_user_params[:utitle]=params[:utitle]
      new_user_params[:udid]=params[:udid]
      new_user_params[:usort=params[:usort]

      @user=User.new(new_user_params)
    end

    respond_to do |format|
      if @user.save
        sign_in(@user)  #written session token. @xieyinghua
        
        format.html { redirect_to @user, notice: 'User was successfully created. Please Sign-in' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if params[:cros]=='y'
      #create from cros post. @xieyinghua
      id=params[:id]
      @user=User.where("id='#{id}'").first
      @user.uid=params[:uid]
      @user.upw=params[:upw]
      @user.uname=params[:uname]
      @user.upower=params[:upower]
      @user.uphone=params[:uphone]
      @user.utitle=params[:utitle]
      @user.udid=params[:udid]
      @user.usort=params[:usort]
    end

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
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
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:uid, :upw, :uname, :utitle, :upower, :usort, :uphone, :udid)
    end
end
