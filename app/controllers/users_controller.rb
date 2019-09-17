class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show]
  before_action :correct_user, only: [:show, :index]
  
  def index
    @users = User.order(id: :desc).page(params[:page]).per(25)
  end

  def show
    @user = User.find(params[:id])
    @tasks = @user.tasks.order(id: :desc).page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end

  private
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_url
    end
  end
  

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
