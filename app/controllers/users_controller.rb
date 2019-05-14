class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  #use for android search by title. @xieyinghua
  def search_by_login
    uid=params[:uid]
    upw=params[:upw]
    @user=User.where("uid='#{uid}' and upw='#{upw}'").first

    respond_to do |format|
      if @user!=nil
        format.html { render :show }
        format.json { render json: @user, status: :ok }
      else
        @user = User.all.first
        format.html { render :show }
        format.json { render json: nil, status: :ok }
      end
    end
  end

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
      new_user_params=Hash.new
      new_user_params[:uid]=params[:uid]
      new_user_params[:upw]=params[:upw]
      new_user_params[:uname]=params[:uname]
      new_user_params[:uphone]=params[:uphone]

      if params[:upower]!=nil
        new_user_params[:upower]=params[:upower]
      else
        new_user_params[:upower]='審核中'
      end
      if params[:utitle]!=nil
        new_user_params[:utitle]=params[:utitle]
      else
        new_user_params[:utitle]='會員'
      end
      if params[:udid]!=nil
        new_user_params[:udid]=params[:udid]
      else
        new_user_params[:udid]=''
      end
      if params[:usort]!=nil
        new_user_params[:usort]=params[:usort]
      else
        new_user_params[:usort]=0
      end
          

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
      #update from cros post. @xieyinghua
      new_user_params=user_params
      new_user_params[:uid]=params[:uid]
      new_user_params[:upw]=params[:upw]
      new_user_params[:uname]=params[:uname]
      new_user_params[:uphone]=params[:uphone]

=begin
      if params[:upower]!=nil
        new_user_params[:upower]=params[:upower]
        new_user_params[:utitle]=params[:utitle]
        new_user_params[:udid]=params[:udid]
        new_user_params[:usort]=params[:usort]
      else
        new_user_params[:upower]='會員'
        new_user_params[:utitle]='會員'
        new_user_params[:udid]=''
        new_user_params[:usort]=1
      end
=end

      user_params=new_user_params
    else
      #update from page post. @xieyinghua
      user_params=params[:user]


      #need set value one by one, i not sure why. @xieyinghua
      new_user_params=Hash.new
      new_user_params[:uid]=user_params[:uid]
      new_user_params[:upw]=user_params[:upw]
      new_user_params[:uname]=user_params[:uname]
      new_user_params[:uphone]=user_params[:uphone]
      new_user_params[:upower]=user_params[:upower]
      new_user_params[:utitle]=user_params[:utitle]
      new_user_params[:udid]=user_params[:udid]
      new_user_params[:usort]=user_params[:usort]


      user_params=new_user_params
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
